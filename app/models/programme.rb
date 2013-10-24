# == Schema Information
#
# Table name: programmes
#
#  id                          :integer       not null, primary key
#  code                        :string(8)     not null
#  description                 :string(38)    not null
#  deleted                     :boolean       not null
#  created_at                  :datetime      
#  updated_at                  :datetime      
#  commit_episode              :decimal(8, 2) 
#  budget_start                :datetime      
#  budget_method               :string(1)     
#  budget_wording              :string(18)    
#  budget_details              :string(78)    
#  budget_internal_only        :boolean       
#  detail_payments_other       :boolean       
#  internal_only               :boolean       not null
#  reminder_on                 :boolean       not null
#  incl_zero_advice            :boolean       not null
#  claim_limit_count           :integer       
#  claim_limit_claim_status_id :integer       
#  claim_limit_claim_comment   :string(18)    
#  same_day_claim_status_id    :integer       
#  same_day_claim_comment      :string(18)    
#  claim_limit_period_mths     :integer       
#

class Programme < ActiveRecord::Base
  attr_protected :id
  

  CPLUS = 1; # Care Plus - Harbour Health
  CVDR = 2; # Cardio Vascular Disease Risk - Edge
  DIAB = 3; # Diabetes - Harbour Health + Wanganui Regional Pho 
  ASTH = 4; # Asthma - Harbour Health
  SIA = 5; # SIA - Harbour Health
  B4SC = 6; # B4 School Check  - Harbour Health + Hawkes Bay
  SIAA = 7; # SIA Allocated - Harbour Health
  PMHO = 8; # Lifestyle Options (MH)  - Harbour Health
  
  SL = 9; # Skin Lesions - Wanganui Regional Pho
  CX = 10; # Cervical Screening - Wanganui Regional Pho
  CPW = 11; # Care Plus Whanganui - Wanganui Regional Pho
  PCMH = 12; # Primary Care MH  - Wanganui Regional Pho
  
  TAXI = 13; # Transport Authorisation - Well Dunedin
  U25 = 14; # U25 Sexual Health - Well Dunedin
  THC = 15; # Targeted Health Check - Well Dunedin
  CPWD = 16; # Care Plus Well Dunedin - Well Dunedin
  PALC = 17; # Palliative Care Visit - Well Dunedin
  PMHC = 18; # Primary MH Consult - Well Dunedin
  MCVDM = 19; # Mens CVD Management - Well Dunedin
  
  SCSWR = 20; # Smoking Cessation - Wanganui Regional Pho
  DSME = 21; # Diabetes Self Management Education - Harbour Health
  SATM = 22; # Smoking Cessation - ATM Tool - Harbour Health
  PODA = 23; # Podiatry - Harbour Health
  BAW = 24; # Better @ Work - Habrour Health
  
  PDAC = 25; # Alcohol Screening and Assess - Whanganui
  PNAP = 26; # Post-natal Adjustment Programme - Hawkes Bay
  SMEAR = 27; # Smear Claim - Waiora
  ETHERAPY = 28; # E-Therapy - Harbour Health
  
  WD24HBP = 35;  # 24 Hour Blood Pressure Monitor - Well Dunedin
  
  validates_length_of :code, :within => 2..8, :allow_nil => false
  validates_length_of :description, :within => 2..38, :allow_nil => false
  validates_uniqueness_of :code
  validates_length_of :budget_wording, :maximum => 18, :allow_nil => true
  validates_length_of :budget_details, :maximum => 78, :allow_nil => true
  validates_numericality_of :claim_limit_count, :allow_nil => true  
  validates_numericality_of :claim_limit_period_mths, :allow_nil => true  
  validates_length_of :claim_limit_claim_comment, :maximum => 18, :allow_nil => true
  validates_length_of :same_day_claim_comment, :maximum => 18, :allow_nil => true
  
  
  has_many :fee_schedules
  has_many :elements, :class_name => "ProgrammeElement", :order => 'position'  
  has_many :budgets, :include => :organisation, :order  => 'organisations.name'
  
  def caption
    # Return heading for a patient
    if ( self.id.blank? )
      return "New Programme"
    end
    "#{self.description}"
  end 

  # Return array of all organisations and there budget
  def budgets_for_organisations
    return nil if ( self.budget_start.blank? )
    query=Query.find_by_sql([
            "select o.name organisation_name, b.budget, sum(f.is_a_entry_service) episode_count, count(c.id) claim_count, sum(c.amount) actual_amount\n"+
            "from budgets b\n"+
            "  join organisations o on o.id = b.organisation_id\n"+
            "  left join claims c on c.cost_organisation_id = o.id and c.programme_id = b.programme_id\n"+
            "            and c.invoice_date >= ? and c.invoice_date < ? and c.claim_status_id <= 6\n"+
            "  left join fee_schedules f on f.id = c.fee_schedule_id\n"+
            "where b.programme_id = ?\n\n"+
            "group by o.name, b.budget\n"+
            "order by o.name", self.budget_start,self.budget_start.next_year,self.id ])
#            "select o.name organisation_name, b.budget, sum(f.treatment_entry) episode_count, count(c.id) claim_count, sum(c.amount) actual_amount\n"+
#            "from claims c\n"+
#            "  left join organisations o on o.id = c.cost_organisation_id\n"+
#            "  left join budgets b on b.programme_id = c.programme_id and b.organisation_id = c.cost_organisation_id\n"+
#            "  left join fee_schedules f on f.id = c.fee_schedule_id\n"+
#            "where c.invoice_date >= ? and c.invoice_date < ? and  c.programme_id = ?\n"+
#            "and c.claim_status_id <= 6\n"+
#            "group by o.name, b.budget\n"+
#            "order by o.name", self.budget_start,self.budget_start.next_year,self.id ])
     query
  end
  
 
end
