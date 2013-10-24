# == Schema Information
#
# Table name: fee_schedules
#
#  id                     :integer       not null, primary key
#  programme_id           :integer       not null
#  code                   :string(8)     not null
#  description            :string(38)    not null
#  fee                    :decimal(8, 2) 
#  detail                 :string(78)    
#  gl_account_no          :string(18)    
#  is_the_default         :boolean       not null
#  deleted                :boolean       not null
#  created_at             :datetime      
#  updated_at             :datetime      
#  on_hold                :boolean       not null
#  on_new_claim_status_id :integer       
#  on_new_claim_comment   :string(18)    
#  is_a_entry_service     :integer       default(1)
#  is_a_exit_service      :integer       default(1)
#  is_a_practice_service  :integer       default(1)
#  is_a_declined_service  :integer       default(0), not null
#  is_a_dnr_service       :integer       default(0), not null
#  reminder_on            :boolean       not null
#  reminder_in_weeks      :integer       
#  reminder_note          :string(78)    
#

class FeeSchedule < ActiveRecord::Base
  attr_protected :id
  
  DIAB_DECLINED = 39
  B4SC_DECLINED = 69
  
  PLMH_INITIAL = 800
  PLMH_OUTCOME = 817
  
  CPW_DIS_ENROLLMENT = 1102
  
  DSME_REFERRAL = 2100
  DSME_NON_RESPONDER = 2101
  DSME_IN_COMPLETE = 2102
  DSME_COMPLETE = 2103
  
  PODA_REFERRAL = 2300
  PODA_FIRST_ASSESSMENT = 2301
  PODA_SINGLE_VISIT = 2304
  
  PNAP_REFERRAL = 2600
  PNAP_END_OF_CARE = 2602
  
  validates_length_of :code, :within => 2..8, :allow_nil => false
  validates_length_of :description, :within => 2..38, :allow_nil => false
  validates_uniqueness_of :code, :scope => 'programme_id'
  validates_presence_of :programme_id
#  validates_presence_of :is_a_entry_service
  
  validates_length_of :gl_account_no, :maximum => 18, :allow_nil => true  
  validates_numericality_of :fee, :allow_nil => true  
  validates_length_of :detail, :maximum => 78, :allow_nil => true
  validates_length_of :on_new_claim_comment, :maximum => 18, :allow_nil => true
  
  belongs_to :programme  
  belongs_to :on_new_claim_status, :class_name => 'ClaimStatus'
  
  def self.choices_for_select(programme_id)
    FeeSchedule.find(:all,:select=>"id, description",
       :conditions => { :programme_id => programme_id }, :order=>"description").map do |m| 
         [m.description, m.id ]
       end
  end

  def caption
    # Return string sutable for a heading or link to
    if ( self.id.blank? )
      return "New Fee Schedule"
    end
    "#{self.programme.description}::#{self.description}"
  end    
  
end
