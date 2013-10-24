# == Schema Information
#
# Table name: claims
#
#  id                   :integer       not null, primary key
#  invoice_date         :datetime      not null
#  invoice_no           :string(18)    
#  date_lodged          :datetime      not null
#  date_service         :datetime      not null
#  patient_id           :integer       not null
#  programme_id         :integer       not null
#  fee_schedule_id      :integer       not null
#  amount               :decimal(8, 2) 
#  organisation_id      :integer       not null
#  host_provider_id     :integer       
#  service_provider_id  :integer       
#  clinical_information :text          
#  comment              :string(78)    
#  claim_status_id      :integer       default(5), not null
#  payment_run_id       :integer       default(0), not null
#  cost_organisation_id :integer       not null
#  created_at           :datetime      
#  updated_at           :datetime      
#  cplus_enrolled       :integer       
#  huhc_holder          :integer       
#


# NOTE: Date lodged is used to determine which budget this will come off. 

class Claim < ActiveRecord::Base
  PAGE_SIZE = 60 # 60 Claims on a page. 
  
  attr_protected :id

  validates_presence_of :organisation_id
  validates_presence_of :invoice_date
  validates_presence_of :date_lodged
  validates_presence_of :date_service
  
  validates_presence_of :patient_id
  validates_presence_of :programme_id
  validates_presence_of :fee_schedule_id
  validates_presence_of :claim_status_id
  
  belongs_to :organisation
  belongs_to :host_provider, :class_name => 'Provider'
  belongs_to :service_provider, :class_name => 'Provider'
  belongs_to :patient
  belongs_to :programme
  belongs_to :fee_schedule
  belongs_to :claim_status
  belongs_to :cost_organisation, :class_name => 'Organisation', :foreign_key => 'cost_organisation_id'
  
  def before_validation
      # Default values if not specified
      self.date_service ||= self.invoice_date
      self.date_lodged ||= Date.today
      self.host_provider_id ||= self.service_provider_id
      self.service_provider_id ||= self.host_provider_id
      self.cost_organisation_id ||= self.organisation_id
  end

  def id_formatted
    self.id.blank? ? '' : ( "#%6.6i" % self.id )
  end
  
  def caption
    # Return heading for a patient
    if ( self.id.blank? )
      return "New Claim"
    end
    '%5.5i' % self.id
  end 
  
  # Return list of claims, given a ClaimFilter pagenated by Claim::PAGE_SIZE, if page_no is < 0, all claims are returned
  def self.find_by_filter(claim_filter,page_no)
    conditions = claim_filter.build_conditions(nil);
    Claim.find(:all,:conditions => conditions,  :offset => ( page_no >= 0 ? page_no*(Claim::PAGE_SIZE) : nil ), 
                     :limit => ( page_no >= 0 ? Claim::PAGE_SIZE : nil ) , :order => ( claim_filter.order_by.blank? ? 'invoice_date desc' : claim_filter.order_by ));
  end
  
  def self.held(page_no)
    # return list of claims on hold, Pagenated, By date last updated. 
    Claim.find(:all,:conditions => ['claim_status_id = ?',ClaimStatus::HELD ], :offset => page_no*(Claim::PAGE_SIZE), :limit => Claim::PAGE_SIZE, :order => 'invoice_date desc' );
  end
  
  def data=(arg)
    @data = arg
  end
  
  # Returns the active record, containg the claims data elements, A new record if blank !!
  def data
    @data ||= ClaimsData.find_by_id(self.id) unless self.id.blank?
    @data ||= ClaimsData.new
    @data.id = self.id
    @data
  end

  # return csv of claim data using ClaimFilter, For downloading to excel 
  def self.csv_by_filter(claim_filter,identifiable=false)
    require 'faster_csv'
    
    # conditions = ["1=1 and id > 1000 and id < 1100 "]
    conditions = claim_filter.build_conditions(nil)
    # since using sql, not class directely need to prepend column names with "c."
    conditions[0].gsub!(/and /,'and c.')
    
    self.csv_by_conditions(conditions,identifiable)
  end
  
  
  # return csv of claim data using conditions. Columns should use the claims alias of c, e.g. c.invoice_no
  def self.csv_by_conditions(conditions,identifiable=false)
    require 'faster_csv'
    
    query = Query.find(:all,
      :select => 
        "c.id claim_id, p.id patient_id, p.nhi_no nhi_no,\n"+

        "p.family_name family_name, p.given_names given_names,\n"+
        "p.street street, p.suburb suburb, p.city city, p.post_code post_code, p.phone phone,\n"+ 
        
        "convert(varchar(10),p.date_of_birth,120) date_of_birth,\n"+
        "dbo.age(p.date_of_birth, c.date_service) age, dbo.agerange_gms(p.date_of_birth, c.date_service) age_range,\n"+
        "p.gender_id gender,\n"+
        "e.level1_ethnicity_id ethnicity_level1_id, el1.description ethnicity_level1,\n"+
        "p.ethnicity_id ethnicity_id, e.description ethnicity,\n"+
        "p.ethnicity_2_id ethnicity_2_id, e2.description ethnicity_2,\n"+
        "p.ethnicity_3_id ethnicity_3_id, e3.description ethnicity_3,\n"+
        "p.quintile quintile, c.cplus_enrolled, c.huhc_holder, po.name registered_with,\n"+
        
        "convert(varchar(10),c.invoice_date,120) invoice_date, c.invoice_no invoice_no,\n"+
        "convert(varchar(10),c.date_service,120) date_service,\n"+
        "pr.description programme, se.description service, c.amount amount,\n"+
        "cs.description claim_status, c.payment_run_id paid_payment_run, c.comment comment,\n"+
        "co.name practice, hp.name host_provider, hp.registration_no host_registration_no, \n"+
        "sp.name service_provider, sp.registration_no service_registration_no, spt.description provider_type,\n"+
        "cco.name cost_practice, \n"+
        "d.*,\n"+
        "p.is_care_plus care_plus, cpc.description cp_criteria,cpc2.description cp_criteria_2,cpc3.description cp_criteria_3,cpc4.description cp_criteria_4,\n"+
        "p.care_plus_condition cp_condition, p.care_plus_condition_2 cp_condition_2, p.care_plus_condition_3 cp_condition_3, p.care_plus_condition_4 cp_condition_4",
       :from => "claims c",
       :joins => 
        "left join patients p on p.id = c.patient_id \n"+
        " left join ethnicities e on e.id = p.ethnicity_id\n"+
        "  left join level1_ethnicities el1 on el1.id = e.level1_ethnicity_id\n"+
        " left join ethnicities e2 on e2.id = p.ethnicity_2_id\n"+
        " left join ethnicities e3 on e3.id = p.ethnicity_3_id\n"+
        " left join organisations po on po.id = p.organisation_id\n"+
        " left join care_plus_criterias cpc on cpc.id = p.care_plus_criteria_id\n"+
        " left join care_plus_criterias cpc2 on cpc2.id = p.care_plus_criteria_2_id\n"+
        " left join care_plus_criterias cpc3 on cpc3.id = p.care_plus_criteria_3_id\n"+
        " left join care_plus_criterias cpc4 on cpc4.id = p.care_plus_criteria_4_id\n"+
        "left join programmes pr on pr.id = c.programme_id\n"+
        "left join fee_schedules se on se.id = c.fee_schedule_id\n"+
        "left join organisations co on co.id = c.organisation_id\n"+
        "left join organisations cco on cco.id = c.cost_organisation_id\n"+
        "left join providers hp on hp.id = c.host_provider_id\n"+
        "left join providers sp on sp.id = c.service_provider_id\n"+
        " left join provider_types spt on spt.id = sp.provider_type_id\n"+
        "left join claim_statuses cs on cs.id = c.claim_status_id\n"+
        "  left join claims_data d on d.id = c.id",
       :order => "c.invoice_date, c.invoice_no",
       :conditions => conditions )
     
    # The attributes to output in order. 
    attributes = ['claim_id', 'patient_id', 'nhi_no'];

    if ( identifiable  ) 
      attributes.concat( 
      [ 'family_name', 'given_names', 
        'street', 'suburb', 'city', 'post_code',
        'phone'] )
    end
        
    attributes.concat( 
      [ 'date_of_birth', 'age', 'age_range','gender', 
        'ethnicity_level1_id', 'ethnicity_level1', 
        'ethnicity_id', 'ethnicity', 
        'ethnicity_2_id', 'ethnicity_2', 
        'ethnicity_3_id', 'ethnicity_3', 
        'quintile', 'cplus_enrolled', 'huhc_holder', 'registered_with', 
        'invoice_date', 'invoice_no', 'date_service', 'programme', 'service', 
        'amount', 'claim_status', 'paid_payment_run', 'comment', 
        'practice', 'host_provider', 'host_registration_no',
        'service_provider','service_registration_no','provider_type', 'cost_practice'] )
     # Add in the claims data columns 
     attributes.concat( ClaimsData.columns.map { |e| e.name } )
     # Add in the care plus columns at the end
     attributes.concat( 
       ['care_plus', 
        'cp_criteria','cp_criteria_2','cp_criteria_3','cp_criteria_4',
        'cp_condition','cp_condition_2','cp_condition_3','cp_condition_4'] )
     # Delete any attributes that are blank for all rows. 
     attributes.reject! do |e| 
        query.inject(true) { |result,row| result &&= row.read_attribute(e).blank? }
     end
     
     if ( query.length <= 1 ) 
        # Output each data item in a row. 
        retvar=FasterCSV.generate do |csv|
          attributes.each do |e| 
            csv << query.inject([e]) { |result,row| result << row.read_attribute(e) }
          end
        end
      else
        retvar=FasterCSV.generate do |csv|
          csv << attributes # Header row.
          query.each do |r| 
            csv << attributes.inject([]) { |result,e| result << r.read_attribute(e) }
          end
        end
    end
    retvar
  end     
  
end
  
