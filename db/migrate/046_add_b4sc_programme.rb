class AddB4scProgramme < ActiveRecord::Migration
  def self.up
    Programme.create_with_id 6, :code => 'B4SC', :description => 'B4 School Check'
    
    FeeSchedule.delete_all( 'programme_id = 6' )
    
    FeeSchedule.create_with_id 60, :programme_id => 6, :code => 'B4SCPC', :description => 'Practice Claim', :fee => 60.00, :gl_account_no => '6-0000'
    FeeSchedule.create_with_id 61, :programme_id => 6, :code => 'B4SCCC', :description => 'Coordinator Claim', :fee => 10.00,  :gl_account_no => '6-0000'
    FeeSchedule.create_with_id 62, :programme_id => 6, :code => 'B4SCNC', :description => 'No Claim', :fee => 0, :gl_account_no => '6-0000'
  end

  def self.down
  end
end
