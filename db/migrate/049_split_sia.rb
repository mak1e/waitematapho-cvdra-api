class SplitSia < ActiveRecord::Migration
  def self.up
    Programme.create_with_id 7, :code => 'SIAA', :description => 'SIA Allocated'
    
    # Programme# 5 Is SIA
    Claim.update_all( 'programme_id = 7', 'programme_id = 5 and fee_schedule_id in (52,53,55)' );
    FeeSchedule.update_all( 'programme_id = 7', 'programme_id = 5 and id in (52,53,55)' );
    
    # id  description 
    # 50  Adolescent Clinic 
    # 51  Community Voucher 
    # 52  Skin Lesion 
    # 53  Terminal Care 
    # 54  Podiatry Invoice  
    # 55  Radiology 
    # 56  Interpretation  
    # 57  Podiatry Referral 
  end

  def self.down
  end
end
