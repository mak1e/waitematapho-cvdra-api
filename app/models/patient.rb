# == Schema Information
#
# Table name: patients
#
#  id                      :integer       not null, primary key
#  nhi_no                  :string(7)     
#  family_name             :string(40)    not null
#  given_names             :string(40)    
#  date_of_birth           :datetime      
#  gender_id               :string(1)     
#  ethnicity_id            :integer       
#  quintile                :integer       
#  dhb_id                  :string(3)     
#  comment                 :string(78)    
#  deleted                 :boolean       not null
#  created_at              :datetime      
#  updated_at              :datetime      
#  organisation_id         :integer       
#  is_care_plus            :integer       default(0), not null
#  care_plus_criteria_id   :integer       
#  care_plus_criteria_2_id :integer       
#  care_plus_criteria_3_id :integer       
#  care_plus_criteria_4_id :integer       
#  care_plus_condition     :string(18)    
#  care_plus_condition_2   :string(18)    
#  care_plus_condition_3   :string(18)    
#  care_plus_condition_4   :string(18)    
#  ethnicity_2_id          :integer       
#  ethnicity_3_id          :integer       
#  is_huhc_holder          :integer       
#  street                  :string(45)    
#  suburb                  :string(30)    
#  city                    :string(30)    
#  post_code               :string(10)    
#  phone                   :string(14)    
#

class Patient < ActiveRecord::Base
  attr_protected :id

  belongs_to :gender
  belongs_to :ethnicity
  belongs_to :ethnicity_2, :class_name => "Ethnicity"   
  belongs_to :ethnicity_3, :class_name => "Ethnicity"   
  belongs_to :dhb
  belongs_to :organisation
  belongs_to :care_plus_criteria
  belongs_to :care_plus_criteria_2, :class_name => "CarePlusCriteria"   
  belongs_to :care_plus_criteria_3, :class_name => "CarePlusCriteria"   
  belongs_to :care_plus_criteria_4, :class_name => "CarePlusCriteria"   
  
  has_many :claims, :order => 'invoice_date desc'
  has_many :access_logs, :order => 'id desc'
  
  before_validation :normalize_data
  
  validates_format_of :nhi_no, :with => /^[A-HJ-NP-Z]{3}[0-9]{4}$/, :message => "Invalid NHI No",  :allow_nil => true
  validates_length_of :nhi_no, :maximum => 7, :allow_nil => true
  validates_length_of :family_name, :within => 1..40, :allow_nil => false
  validates_length_of :given_names, :maximum => 40, :allow_nil => true
  validates_length_of :comment, :maximum => 78, :allow_nil => true

  validates_length_of :street, :maximum => 45, :allow_nil => true
  validates_length_of :suburb, :maximum => 30, :allow_nil => true
  validates_length_of :city, :maximum => 30, :allow_nil => true
  validates_length_of :post_code, :maximum => 10, :allow_nil => true
  validates_length_of :phone, :maximum => 14, :allow_nil => true
  
  # validates_uniqueness_of :nhi_no
  
  
  @@patched_date_of_birth_type=false
  def after_initialize
    if ( !@@patched_date_of_birth_type )
       date_of_birth_column = Patient.columns_hash['date_of_birth']
       date_of_birth_column.type= :date
       @@patched_date_of_birth_type=true
    end
  end
  
  def normalize_data
    # Clean up date 
    
    self.family_name.strip! if self.family_name
    self.family_name.upcase!  if self.family_name
    
    self.given_names.strip!  if self.given_names
    self.given_names.upcase!  if self.given_names
    
    self.nhi_no = nil if self.nhi_no.blank?
  end  
  
 # Return name of patient (no nhi)
  def name
    if ( self.id.blank? )
      return "New Patient"
    end
    result=self.family_name;
    result+= ", #{self.given_names.capitalize}" if  !self.given_names.blank?;
    result
  end
  
  # Return heading for a patient. i.e Name + NHI
  def caption
    result=self.name
    result+= " (#{self.nhi_no})" unless self.nhi_no.blank?;
    result
  end  
  
  def age
   tod=Date.today
   dob=self.date_of_birth
   if ( dob.nil? )
     nil
   else
     calc=tod.year-dob.year
     calc-=1 if (tod.month < dob.month) || ((tod.month == dob.month) && (tod.day < dob.day))
     calc
   end
 end
 
  
  def self.find_or_add(attributes)
    # find or add a patient, returns nil if fails. 
    return nil  if attributes[:date_of_birth].blank? # must have dob
    
    comment = ''
    nhi_no = attributes[:nhi_no].strip[0,7].upcase unless attributes[:nhi_no].blank?
    
    family_name = attributes[:family_name].strip[0,40].upcase unless attributes[:family_name].blank?
    family_name.toutf7! unless family_name.blank? # Some system may use extended ascii 
    
    given_names = attributes[:given_names].strip[0,40].upcase unless attributes[:given_names].blank?
    given_names.toutf7! unless given_names.blank?  # Some system may use extended ascii 
    date_of_birth = Date.DateParseYyyyMmDd(attributes[:date_of_birth]) unless attributes[:date_of_birth].blank?
    
    # Allow NHI only messages. 
    if ( family_name.blank? && !nhi_no.blank? )
       family_name = 'NHI';
       given_names = nhi_no;
    end
    
    # Allow Anonymous only messages. 
    if ( family_name.blank? && nhi_no.blank? )
       family_name = 'ANONYMOUS';
       external_id = attributes[:external_id]
       
       return nil if external_id.blank? # Must have at least external_id
       given_names = Digest::MD5.hexdigest(external_id).upcase.strip[0,8]
    end
    
    # Blank out invalid nhi_no's sent from external system. 
    unless ( nhi_no.blank? )
      unless ( nhi_no =~ /^[A-HJ-NP-Z]{3}[0-9]{4}$/ )
         comment = "Invalid NHI #{nhi_no}"
         nhi_no = nil
     end
    end    
    
    gender_id = attributes[:gender].strip[0,1].upcase unless attributes[:gender].blank?
    gender_id = 'F' if gender_id == 'U'
    
    ethnicity_id = attributes[:ethnicity].strip[0,2].upcase.to_i unless attributes[:ethnicity].blank?
    ethnicity_id = nil if Ethnicity::VALID_IDS.index(ethnicity_id).blank?

    ethnicity_2_id = attributes[:ethnicity_2].strip[0,2].upcase.to_i unless attributes[:ethnicity_2].blank?
    ethnicity_2_id = nil if Ethnicity::VALID_IDS.index(ethnicity_id).blank?

    ethnicity_3_id = attributes[:ethnicity_3].strip[0,2].upcase.to_i unless attributes[:ethnicity_3].blank?
    ethnicity_3_id = nil  if Ethnicity::VALID_IDS.index(ethnicity_id).blank?

    quintile = attributes[:quintile].to_i unless attributes[:quintile].blank?
    quintile = nil if [1,2,3,4,5].index(quintile).blank?
    
    is_care_plus = 0 unless attributes[:is_care_plus].blank?
    is_care_plus = 1 if (attributes[:is_care_plus] == 'Y' or attributes[:is_care_plus] == '1') 
    
    is_huhc_holder = 0 unless attributes[:is_huhc_holder].blank?
    is_huhc_holder = 1 if (attributes[:is_huhc_holder] == 'Y' or attributes[:is_huhc_holder] == '1') 
    
    dhb_id = attributes[:dhb].strip[0,3].upcase unless attributes[:dhb].blank?
    
    organisation_id = attributes[:organisation_id].to_i unless attributes[:organisation_id].blank?
    organisation_id = nil if ( organisation_id == 0 || family_name == 'ANONYMOUS' )

    street = attributes[:street].strip[0,45].titleize unless attributes[:street].blank?
    suburb = attributes[:suburb].strip[0,30].titleize unless attributes[:suburb].blank?
    city = attributes[:city].strip[0,30].titleize unless attributes[:city].blank?
    post_code = attributes[:post_code].strip[0,10].upcase unless attributes[:post_code].blank?
    
    patient = nil
    # Find by NHI and DOB
    patient = Patient.find(:first, :conditions => [ 'nhi_no = ? and date_of_birth = ?  and deleted = ?', nhi_no, date_of_birth, false ]) unless nhi_no.blank?;
    
    if ( patient.blank? )
      # Not found/No NHI, find by Name and Dob
      patient = Patient.find(:first, :conditions => [ 'family_name = ? and given_names like ? and date_of_birth = ? and deleted = ?',family_name, given_names[0,9]+'%' ,date_of_birth, false ]) unless  family_name.blank? || given_names.blank?
    end
    if ( patient.blank? && family_name.blank? && !organisation_id.blank? )
      # Not found/No Name and not found by NHI, must resort to just dob within the organisation
      if gender_id.blank? 
        patient = Patient.find(:first, :conditions => [ 'date_of_birth = ?  and organisation_id = ? and deleted = ?', date_of_birth, organisation_id, false ])
      else
        patient = Patient.find(:first, :conditions => [ 'date_of_birth = ?  and gender_id = ? and organisation_id = ? and deleted = ?', date_of_birth, gender_id, organisation_id, false ])
      end
    end
    
    patient_changed = false
    if ( patient.blank? )
      # Add the patient
      patient = Patient.new
      patient.family_name = '-'
      patient.date_of_birth = date_of_birth
      patient.gender_id = 'F'
      patient.deleted = 0
      patient.is_care_plus = 0
      patient.is_huhc_holder = 0
      patient_changed = true
      # patient.save!
    end
    
    # Update patient details
    unless ( nhi_no.blank? || patient.nhi_no == nhi_no )
      patient.nhi_no = nhi_no
      patient_changed = true
    end
    unless ( family_name.blank? || patient.family_name == family_name )
      if ( patient.id.blank? || ( family_name != 'NHI' ))
        # Dont overwrite, family name with a NHI only name 
        patient.family_name = family_name
        patient_changed = true
      end
    end
    unless ( given_names.blank? || patient.given_names == given_names )
      if ( patient.id.blank? || ( family_name != 'NHI' ))
        # Dont overwrite, family name with a NHI only name 
        patient.given_names = given_names
        patient_changed = true
      end
    end
    unless ( gender_id.blank? || patient.gender_id == gender_id )
      patient.gender_id = gender_id
      patient_changed = true
    end
    unless ( ethnicity_id.blank? || patient.ethnicity_id == ethnicity_id )
      patient.ethnicity_id = ethnicity_id
      patient_changed = true
    end
    unless ( ethnicity_2_id.blank? || patient.ethnicity_2_id == ethnicity_2_id )
      patient.ethnicity_2_id = ethnicity_2_id
      patient_changed = true
    end
    unless ( ethnicity_3_id.blank? || patient.ethnicity_3_id == ethnicity_3_id )
      patient.ethnicity_3_id = ethnicity_3_id
      patient_changed = true
    end
    unless ( quintile.blank? || patient.quintile == quintile )
      patient.quintile = quintile
      patient_changed = true
    end
    unless ( dhb_id.blank? || patient.dhb_id == dhb_id )
      patient.dhb_id = dhb_id
      patient_changed = true
    end
    unless ( comment.blank? || patient.comment == comment )
      patient.comment = comment
      patient_changed = true
    end
    unless ( is_care_plus.blank? || patient.is_care_plus == is_care_plus )
      patient.is_care_plus = is_care_plus
      patient_changed = true
    end
    unless ( is_huhc_holder.blank? || patient.is_huhc_holder == is_huhc_holder )
      patient.is_huhc_holder = is_huhc_holder
      patient_changed = true
    end
    unless ( dhb_id.blank? || patient.dhb_id == dhb_id )
      patient.dhb_id = dhb_id
      patient_changed = true
    end
    unless ( street.blank? || patient.street == street )
      patient.street = street
      patient_changed = true
    end
    unless ( suburb.blank? || patient.suburb == suburb )
      patient.suburb = suburb
      patient_changed = true
    end
    unless ( city.blank? || patient.city == city )
      patient.city = city
      patient_changed = true
    end
    unless ( post_code.blank? || patient.post_code == post_code )
      patient.post_code = post_code
      patient_changed = true
    end
    
    
    # Only change the organisation_id when null
    unless ( organisation_id.blank? || (!patient.organisation_id.blank?) )
      patient.organisation_id = organisation_id
      patient_changed = true
    end
    # Fill in care plus for Whanganui and WellDunedin
    if patient.is_care_plus
      care_plus_criteria_id = attributes[:care_plus_criteria].strip[0,2].upcase.to_i unless attributes[:care_plus_criteria].blank?
      care_plus_criteria_id = nil if CarePlusCriteria::VALID_IDS.index(care_plus_criteria_id).blank?
      # Only update if have some criteria. As update may be from CBF with no cplus data
      unless care_plus_criteria_id.blank?
        care_plus_criteria_2_id = attributes[:care_plus_criteria_2].strip[0,2].upcase.to_i unless attributes[:care_plus_criteria_2].blank?
        care_plus_criteria_2_id = nil if CarePlusCriteria::VALID_IDS.index(care_plus_criteria_2_id).blank?
        care_plus_criteria_3_id = attributes[:care_plus_criteria_3].strip[0,2].upcase.to_i unless attributes[:care_plus_criteria_3].blank?
        care_plus_criteria_3_id = nil if CarePlusCriteria::VALID_IDS.index(care_plus_criteria_3_id).blank?
        care_plus_criteria_4_id = attributes[:care_plus_criteria_4].strip[0,2].upcase.to_i unless attributes[:care_plus_criteria_4].blank?
        care_plus_criteria_4_id = nil if CarePlusCriteria::VALID_IDS.index(care_plus_criteria_4_id).blank?
        
        # Remove dots after read code...  e.g. H33.11 => H33
        care_plus_condition = attributes[:care_plus_condition].sub(/\..*/,'') unless attributes[:care_plus_condition].blank?
        care_plus_condition_2 = attributes[:care_plus_condition_2].sub(/\..*/,'') unless attributes[:care_plus_condition_2].blank?
        care_plus_condition_3 = attributes[:care_plus_condition_3].sub(/\..*/,'') unless attributes[:care_plus_condition_3].blank?
        care_plus_condition_4 = attributes[:care_plus_condition_4].sub(/\..*/,'') unless attributes[:care_plus_condition_4].blank?
        
        # Update we have some data !!
        patient.care_plus_criteria_id = care_plus_criteria_id
        patient.care_plus_criteria_2_id = care_plus_criteria_2_id
        patient.care_plus_criteria_3_id = care_plus_criteria_3_id
        patient.care_plus_criteria_4_id = care_plus_criteria_4_id
        patient.care_plus_condition = care_plus_condition
        patient.care_plus_condition_2 = care_plus_condition_2
        patient.care_plus_condition_3 = care_plus_condition_3
        patient.care_plus_condition_4 = care_plus_condition_4
        patient_changed = true
      end
      
    end

    # NHI Number may be invalid in the database from a conversion !!
    unless ( patient.nhi_no.blank? )
      unless ( patient.nhi_no =~ /^[A-HJ-NP-Z]{3}[0-9]{4}$/ )
         patient.comment = "Invalid NHI #{patient.nhi_no}"
         patient.nhi_no = nil
     end
    end    
    
    # logger.info("UPDATE PAT #{attributes.inspect}" )  if patient_changed
    patient.save! if patient_changed
    return patient
  end

  CBF_STATUS_OK = '3002'

  # Update the patient table from a CBFHL7OUT_610733_082912.asr file.
  # This call is initiated by :-
  #   ruby script/runner -e production Patient.update_from_asr
  # NOTE: DONT!!! Output anything to the console otherwise, process will crash !!
  # The Registry is updated to allow the status of the update to be reported.
  #
  # The File Format is as follows. 
  # (NOTE: This file is large ~30MB so may take some time to process. )
  # ============================================================================
  # MSH|^~\&|GTPS:CBF|Health Benefits| | |20071207011918||ACK^C90|CBFHL7OUT_610733_120701|P|2.3|||||
  # MSA|AV|CBFHL7IN_610733_112712||||9999^Final Register Status^CBF
  # ZPC|610733||||36|155455|
  # ZPR|Apple Accident + Medical|NHALB|0
  #   ZSA|3004^Deceased Patient Found: Patient has been removed from register
  #     PID||BUQ9119^^^^|w0476DA||RRRRRRRR^CCCCCCCC^SSSSSSSSS^^^^||19211112|M|||^123 ADDRESS^ALBANY^AUCKLAND^^^^|||||||||||21|||||||20070222|
  #     ZRD|^^^^^^|-36.757148|174.710112|Y|^^^^^^^||20060409||20060409|E|0||0||180833|1|D^4|NWA|N||
  #   ZSA|3002^Validated Details Returned: Patient will be included in payment
  #     PID||ARS9767^^^^|w05C880||BBBBBBB^AAAAAAAA^RRRRRR^JAMES^^^||19721002|M|||^123 ADDRESS^BEACHAVEN^AUCKLAND^^^^|||||||||||11||||||||
  #     ZRD|^^^^^^|-36.793817|174.682096|Y|^^^^^^^||20070509||20070509|E|0||0||342100|1|D^4|NWA|N||
  #     PID||BNN3074^^^^|w056434||MMMMMM^KKKKKK^FFFFFFFF^^^^||19511018|M|||^123 ADDRESS^ALBANY^NORTHERN AUCKLAND^^^^|||||||||||10||||||||
  #     ZRD|^^^^^^|-36.754349|174.717177|Y|^^^^^^^||20060327||20071106|E|0||0||180828|2|D^4|NWA|N||
  # ============================================================================

  def self.update_from_asr
    
    status = "#{Time.now} - Register upload started"
    Registry.write_string(Registry::ASR_SECTION,Registry::ASR_STATUS_IDENT,status)
    logger.info( status )
    # puts status
    logger.flush
    
    segment=nil
    start_time = Time.now
    
    # Remove all patients from this organisation. So can do population counts etc...
    Patient.update_all( "organisation_id = null, is_care_plus = 0, is_huhc_holder = 0", "organisation_id is not null" )
    Organisation.update_all( "est_no_patients = 0" )
    
    status=CBF_STATUS_OK # ok 
    attributes = {}
    organisation = nil
    npatients = 0
    npatients_in_org = 0
    
    warnings=''
    tmp_asr = File.join(RAILS_ROOT,'tmp','CBFHL7OUT.asr')
    asr=File.open(tmp_asr,'r')
    i=0
    asr.each_line do |line|
      segment=line.split('|');
      if ( segment[0] == 'ZSA' )
        # ZSA|3002^Validated Details Returned: Patient will be included in payment
        status=segment[1].split('^')[0]
        # logger.info("status #{status}" );
      elsif ( segment[0] == 'ZPR' ) # Change in organisation
        if ( organisation )
          # update the previous organisation's population
          organisation.est_no_patients = npatients_in_org
          organisation.save
        end
        # ZPR|Albany Basin Accident + Medical|NHALB|0
        npatients_in_org = 0
        organisation = nil
        unless segment[2].blank?
          organisation = Organisation.find(:first, :conditions => { :cbf_ident => segment[2] })
          unless organisation
            # MS: 2012-06-28 added an alternative cbd code,to search by.  
            # as changed practice unlcode in LinkTech to PRAC01 etc (for the after hrs project - anonomyours practices id)
            # this had a side effect of changing the code used in the ASR file. A pain !!! 
            organisation = Organisation.find(:first, :conditions => { :cbf_ident_alt => segment[2] })
          end
          unless organisation
            # Not found, try and find via providers cbf ident.
            # NOTE: If ASR is split by provider. May not be in order, so need to reset/fetch est_no_patients
            provider = Provider.find(:first, :conditions => { :cbf_ident => segment[2] })
            organisation = provider.organisation if provider
          end
        end
        
        npatients_in_org = organisation.est_no_patients if organisation
        status = CBF_STATUS_OK
        unless organisation
          msg = "<br>WARNING: Could not identify practice '#{segment[1]}' from ID '#{segment[2]}'"
          # puts msg
          logger.info(msg)
          warnings += msg
        end
      elsif  organisation && ( status == CBF_STATUS_OK )
        if ( segment[0] == 'PID' )
          # PID||ADV8525^^^^|w03DB72||SSSSS^FFFFF^^^^^||19620317|F|||^111 RIVER RD^AVONDALE^AUCKLAND^^^^|||||||||||30~40~23||||||||
          attributes = {}
          
          attributes[:nhi_no]= segment[2].split('^')[0]
          
          split=segment[5].split('^')
          
          attributes[:family_name] = split[0];
          
          attributes[:given_names]= "#{split[1]} #{split[2]}"
          
          attributes[:date_of_birth]= segment[7].split('^')[0]
          attributes[:gender]= segment[8].split('^')[0]
          
          attributes[:ethnicity]=segment[22].split('~')[0] # A repeating element, get 1st ethnicity (max field len 2)
          
          # New Items Address
          address = segment[11].split('^')
          attributes[:street]= address[0]
          attributes[:street]= address[1] if address[0].blank?
          attributes[:suburb]= address[2]
          attributes[:city]= address[3]
          
        elsif ( segment[0] == 'ZRD' )
          # ZRD|^^^^^^|-36.892941|174.683228|Y|^^^^^^^||20050222||20071011|E|0||0||387900|5|D^2|CAK|N||
          attributes[:quintile]=segment[16].split('^')[0]
          attributes[:dhb]=segment[18].split('^')[0]
          attributes[:is_care_plus]='0'
          attributes[:is_care_plus]='1' if ( segment[19].split('^')[0] == 'Y' )
          attributes[:is_huhc_holder]='1' if ( !segment[12].blank? ) # You only get valid expiry dates.
          attributes[:organisation_id]=organisation.id
          if npatients.remainder(1000) == 0
            Registry.write_string(Registry::ASR_SECTION,Registry::ASR_STATUS_IDENT,"Loading... Processed #{npatients} pts in #{(Time.now-start_time).to_i} secs")
            # puts "Processing #{npatients}"
          end
          begin
             patient = Patient.find_or_add(attributes)
          rescue Exception => e
             logger.info("EXCEPTION with #{attributes.inspect},  #{e.class.to_s}:: #{e}")
          end          
          npatients += 1
          npatients_in_org += 1
          
        end
      end
      i += 1
#        if ( i > 100 )
#          break
#        end
    end
    if ( organisation )
      # update the organisation's population
      organisation.est_no_patients = npatients_in_org
      organisation.save
    end
    asr.close
    status = "#{Time.now} - Register upload complete, #{npatients} Patients."
    Registry.write_string(Registry::ASR_SECTION,Registry::ASR_STATUS_IDENT,status+"<br/>"+warnings)
    # puts status
    logger.info( status )
    logger.flush
    File.delete(tmp_asr);
  end
  
  # Set the care plus status, based on the latest 
  # care plus claim. 
  # This is only necessary when enter manaull care plus claim, But dont set care plus flag!!!
  def self.welldun_set_care_plus_status
    Patient.update_all('is_care_plus = 1',
      ["id in (\n"+
       "select c.patient_id\n"+
       "from claims c\n"+
       "  left join patients p\n"+
       "     on p.id = c.patient_id\n"+
       "  left join claims newer_c on newer_c.patient_id = c.patient_id\n"+
       "      and newer_c.date_service > c.date_service and newer_c.programme_id = c.programme_id\n"+
       "where c.date_service > ?\n"+
       "  and c.programme_id = #{Programme::CPWD}\n"+
       "  and p.is_care_plus = 0\n"+
       # Only want if this is the latest claim !!
       "  and newer_c.id is null)\n",Date.today.months_since(-4)])
   end
  
end
