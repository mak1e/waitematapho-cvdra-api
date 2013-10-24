# == Schema Information
#
# Table name: settings
#
#  id                       :integer       not null, primary key
#  name                     :string(40)    not null
#  dhb_id                   :string(3)     
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
#  bank_ac_no               :string(20)    
#  gst_no                   :string(10)    
#  advice_message           :string(78)    
#  created_at               :datetime      
#  updated_at               :datetime      
#  hlink_importer_url       :string(78)    
#  cbf_cap_gl_account_no    :string(18)    
#  cbf_ded_gl_account_no    :string(18)    
#  cbf_cplus_gl_account_no  :string(18)    
#  cbf_under6_gl_account_no :string(18)    
#  cbf_vcla_gl_account_no   :string(18)    
#  cbf_hp_gl_account_no     :string(18)    
#  cbf_sia_gl_account_no    :string(18)    
#

class Settings < ActiveRecord::Base

  GST_PRE = 0.125
  GST_CHANGE = Date.civil(2010,10,1)
  GST_POST = 0.15
  
  attr_protected :id
  
  belongs_to :dhb
 
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
  
  validates_length_of :bank_ac_no, :maximum => 20, :allow_nil => true
  validates_length_of :gst_no, :maximum => 10, :allow_nil => true
  
  validates_length_of :advice_message, :maximum => 78, :allow_nil => true
  
  @@instance = nil
  
  def after_save
    # clear the instance cache
    @@instance = nil
    # Patient #1 is the PHO, so can do bulk invoicing/payment from the pho
    r=Patient.find(1)
    r.family_name = self.name
    r.save
  end
  
  
  def self.instance
    @@instance = Settings.find(1) unless @@instance
    @@instance
  end  
  
  # return the name of the current database connection
  def self.database
    ENV['RAILS_ENV'] ||= 'development'
    self.configurations[ENV['RAILS_ENV']]['database']
  end
  
end
