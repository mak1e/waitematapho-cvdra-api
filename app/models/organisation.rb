# == Schema Information
#
# Table name: organisations
#
#  id                       :integer       not null, primary key
#  name                     :string(40)    not null
#  pho_id                   :integer       
#  residential_street       :string(45)    
#  residential_suburb       :string(30)    
#  residential_city         :string(30)    
#  postal_street            :string(45)    
#  postal_suburb            :string(30)    
#  postal_city              :string(30)    
#  postal_post_code         :string(10)    
#  phone                    :string(14)    
#  fax                      :string(14)    
#  hlink                    :string(8)     
#  per_org_id               :string(8)     
#  bank_ac_no               :string(20)    
#  gst_no                   :string(10)    
#  comment                  :string(78)    
#  est_no_patients          :integer       
#  deleted                  :boolean       not null
#  created_at               :datetime      
#  updated_at               :datetime      
#  cbf_ident                :string(16)    
#  contact_name             :string(18)    
#  on_new_claim_status_id   :integer       
#  on_new_claim_comment     :string(18)    
#  show_names               :boolean       not null
#  not_gst_registered       :boolean       not null
#  cbf_cplus_perage         :decimal(5, 2) 
#  cbf_under6_perage        :decimal(5, 2) 
#  cbf_under6_qtrly_payment :integer       
#  cbf_vcla_perage          :decimal(5, 2) 
#  cbf_vcla_qtrly_payment   :integer       
#  cbf_hp_perage            :decimal(5, 2) 
#  cbf_sia_perage           :decimal(5, 2) 
#  supplier_code            :string(14)    
#  gl_account_no_merge      :string(8)     
#  cbf_supplier_code        :string(14)    
#  cbf_ident_alt            :string(16)    
#  gl_cost_centre           :string(18)    
#

class Organisation < ActiveRecord::Base
  validates_length_of :name, :within => 3..40, :allow_nil => false
  
  validates_length_of :residential_street, :maximum => 45, :allow_nil => true
  validates_length_of :residential_suburb, :maximum => 30, :allow_nil => true
  validates_length_of :residential_city, :maximum => 30, :allow_nil => true
  
  validates_length_of :postal_street, :maximum => 45, :allow_nil => true
  validates_length_of :postal_suburb, :maximum => 30, :allow_nil => true
  validates_length_of :postal_city, :maximum => 30, :allow_nil => true
  validates_length_of :postal_post_code, :maximum => 10, :allow_nil => true
  
  validates_length_of :phone, :maximum => 14, :allow_nil => true
  validates_length_of :fax, :maximum => 14, :allow_nil => true
  validates_length_of :hlink, :maximum => 8, :allow_nil => true
  
  validates_length_of :per_org_id, :maximum => 8, :allow_nil => true
  validates_length_of :bank_ac_no, :maximum => 20, :allow_nil => true
  validates_length_of :gst_no, :maximum => 10, :allow_nil => true
  validates_length_of :cbf_ident, :maximum => 16, :allow_nil => true
  validates_length_of :cbf_ident_alt, :maximum => 16, :allow_nil => true
  validates_length_of :contact_name, :maximum => 18, :allow_nil => true
  
  validates_length_of :comment, :maximum => 78, :allow_nil => true  
  
  validates_uniqueness_of :cbf_ident, :allow_nil => true  
  validates_uniqueness_of :cbf_ident_alt, :allow_nil => true  
  validates_uniqueness_of :hlink, :allow_nil => true  
  validates_uniqueness_of :per_org_id, :allow_nil => true  
  
  belongs_to :pho  
  has_many :providers, :order => 'name' # cant use the word providers as a base method !!!
  belongs_to :on_new_claim_status, :class_name => 'ClaimStatus'
  has_many :claims, :order => 'invoide_date'
  has_many :budgets
  
  before_validation :normalize_data

  def normalize_data
    # Clean up date 
    
    self.cbf_ident = nil if self.cbf_ident.blank?
    self.cbf_ident_alt = nil if self.cbf_ident_alt.blank?
    self.hlink = nil if self.hlink.blank?
    self.per_org_id = nil if self.per_org_id.blank?
  end  
  
  
  def self.choices_for_select
    self.find(:all,:select=>'id, name, residential_suburb', :order=> 'name').map { |m| ["#{m.name}, #{m.residential_suburb}", m.id ]}
  end
  
  # return array of choices for a organisation's who have pho's
  def self.choices_for_select_within_pho(include_id=0)
    include_id=0 if include_id.blank?
    self.find(:all,:select=>'id, name, residential_suburb', :order=> 'name', :conditions => ['((pho_id is not null and deleted = ?) OR ( id = ?)) ',false,include_id]).map { |m| ["#{m.name}, #{m.residential_suburb}", m.id ]}
  end  

  # return array of choices for a organisation select (also group by pho)
  def self.choices_for_select_group_pho(include_id=0)
    include_id=0 if include_id.blank?
    self.find_by_sql('select o.id, o.name, o.deleted, o.residential_suburb, p.name pho_name '+
                     'from organisations o '+
                     '  left join phos p '+
                     '   on p.id = o.pho_id '+
                     "where ( o.deleted = 0 OR o.id = #{include_id.to_s} ) "+
                     'order by isnull(p.id,999), o.name').map { |m| ["#{m.name}, #{m.residential_suburb}", m.id, m.pho_name.blank? ? 'Other' : m.pho_name  ]}
  end
  
  def caption
    # Return heading for a patient
    return "New Organisation" if self.id.blank?
    "#{self.name}, #{self.residential_suburb}"
  end    
  
 
  def post_street
    postal_street.blank? ? residential_street : postal_street
  end
  
  def post_suburb
    postal_street.blank? ? residential_suburb : postal_suburb
  end

  def post_city
    postal_street.blank? ? residential_city : postal_city
  end

  def post_code
    postal_post_code
  end


  def self.find_or_add(attributes)
    
    organisation=nil
    
    # MS: 2012-06-12: Weird!!, we have a healthlink edi that is > 8 characters long !!! mairangimc is 10 characters long !!!, Chop to 8 characters
    attributes[:hlink] = attributes[:hlink][0,8] unless attributes[:hlink].blank?
   
    organisation=self.find(:first, :conditions => { :hlink => attributes[:hlink] } ) unless attributes[:hlink].blank?
    
    # If can't find, try phone number
    if ( !attributes[:phone].blank? && organisation.blank? )
      # Clean up phone number
      phone = attributes[:phone].gsub(/[^0-9]/,'').gsub(/^0./,'')
      # match on 1st three characters of phone number 
      matches=self.find(:all,:conditions => [ "phone like ?",'%'+phone[0,3]+'%'] )
      matches.each do |m|
        clean = m.phone.gsub(/[^0-9]/,'').gsub(/^0./,''); 
        organisation = m if ( phone == clean );
      end
    end
    
    # Last resort, name
    if ( !attributes[:name].blank? && organisation.blank? )
      lookup_name=attributes[:name].strip
      organisation=self.find(:first,:conditions => [ "name like ?",lookup_name[0,16]+'%'] )
    end
    
    if ( organisation.blank? ) 
       return nil if attributes[:name].blank?
       logger.info "INSERT organisations  edi:'#{attributes[:hlink]}' name:'#{attributes[:name]}'"
       organisation=Organisation.new
       organisation.name = attributes[:name] unless attributes[:name].blank?
       organisation.phone = attributes[:phone] unless attributes[:phone].blank?
       organisation.hlink = attributes[:hlink] unless attributes[:hlink].blank?
       # organisation.name = "Unknown edi:#{organisation.hlink}" if organisation.name.blank?
       # organisation.name = "Unknown ph:#{organisation.phone}" if organisation.name.blank?
       organisation = nil unless organisation.save
    end
    organisation
  end
  
  def cbf_note
     retval = ""
     retval += "c-plus " if self.cbf_cplus_perage.to_i > 0
     retval += "under6 " if self.cbf_under6_perage.to_i > 0
     retval += "vcla " if self.cbf_vcla_perage.to_i > 0
     retval += "sia " if self.cbf_sia_perage.to_i > 0
     retval += "hp " if self.cbf_hp_perage.to_i > 0
     retval
  end
  
end
