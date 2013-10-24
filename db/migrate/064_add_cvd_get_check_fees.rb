class AddCvdGetCheckFees < ActiveRecord::Migration
  def self.up
    FeeSchedule.create_with_id 24, :programme_id => 2, :code => 'CVDRAD', :description => 'CVD Risk Diabetic' , :fee => 25.00, :gl_account_no => '6-2117'
    FeeSchedule.create_with_id 25, :programme_id => 2, :code => 'CVDMPD', :description => 'CVD Mgmt Plan Diabetic', :fee => 50.00 , :gl_account_no => '6-2118'
    FeeSchedule.create_with_id 26, :programme_id => 2, :code => 'CVDRPD', :description => 'CVD Risk and Mgmt Diabetic', :fee => 75.00 , :gl_account_no => '6-2118'
  end

  def self.down
    FeeSchedule.delete [24,25,26] 
  end
end
