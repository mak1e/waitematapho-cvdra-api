# == Schema Information
#
# Table name: providers
#
#  id               :integer       not null, primary key
#  registration_no  :string(8)     not null
#  name             :string(40)    not null
#  organisation_id  :integer       not null
#  external_ident   :string(18)    
#  bank_ac_no       :string(20)    
#  gst_no           :string(10)    
#  deleted          :boolean       not null
#  created_at       :datetime      
#  updated_at       :datetime      
#  provider_type_id :integer       
#  seperate_payment :boolean       
#  cbf_ident        :string(16)    
#  supplier_code    :string(14)    
#

class Provider < ActiveRecord::Base
  
  validates_length_of :name, :maximum => 40, :allow_nil => false
  validates_length_of :registration_no, :in => 4..8, :allow_nil => false
  validates_presence_of :organisation_id

  
  validates_length_of :bank_ac_no, :maximum => 20, :allow_nil => true
  validates_length_of :gst_no, :maximum => 10, :allow_nil => true

  belongs_to :organisation
  belongs_to :provider_type
  
  def self.choices_for_select(organisation_id)
    Provider.find(:all,:select=>"id, name, registration_no",
       :conditions => { :organisation_id => organisation_id }, :order=>"name").map do |m| 
         ["#{m.name} \##{m.registration_no}", m.id ]
       end
  end       
   

  def self.find_or_add(attributes)
    return nil if attributes[:registration_no].blank?
    
    # Registration # sometimes have leading zero's strip them
    registration_no = attributes[:registration_no].strip.gsub(/^0+/,'')
    organisation_id = attributes[:organisation_id]
    
    provider=Provider.find(:first,:conditions => [ 'organisation_id = ? and ( registration_no = ? or registration_no = ? or registration_no = ? or registration_no = ?)',organisation_id,registration_no,"0#{registration_no}", "00#{registration_no}", "000#{registration_no}" ] )
    provider=Provider.find(:first, :conditions => { :organisation_id => organisation_id, :external_ident => registration_no}) if provider.blank?
    if ( provider.blank? )
       if attributes[:name].blank? 
         # Check if provider present against another practice
         provider=Provider.find(:first,:conditions => [ '( registration_no = ? or registration_no = ? or registration_no = ?)',registration_no,"0#{registration_no}", "00#{registration_no}" ] )
         attributes[:name] = provider.name unless provider.blank?
       end
       provider=Provider.new
       provider.organisation_id = organisation_id
       provider.registration_no = registration_no
       provider.provider_type_id = ProviderType::DOCTOR if attributes[:registration_body] == 'NZMC'
       provider.provider_type_id = ProviderType::NURSE if attributes[:registration_body] == 'NZNC'
       provider.name = attributes[:name]
       provider.name = "#{attributes[:given_names].capitalize} #{attributes[:family_name].capitalize}" unless attributes[:family_name].blank? && attributes[:given_names].blank?
       provider.name = "Nzmc #{attributes[:registration_no]}"  if provider.name.blank?
       provider = nil unless provider.save
    end
    provider
  end

  def caption
    # Return heading for a patient
    if ( self.id.blank? )
      return "New Provider"
    end
    "#{self.name} [#{self.registration_no}]"
  end 
end
