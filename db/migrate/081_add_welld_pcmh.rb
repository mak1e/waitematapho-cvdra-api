class AddWelldPcmh < ActiveRecord::Migration
  def self.up
    ClaimsData.reset_column_information
    DataField.populate_table    

    Programme.create_with_id 18, :code => 'PMHC', :description => 'Primary MH Consult'
    
    FeeSchedule.create_with_id 1800, :programme_id => 18, :code => 'MHEC', :description => 'Extended Consult', :fee => 36.00, :gl_account_no => '1800-00' 
    FeeSchedule.create_with_id 1801, :programme_id => 18, :code => 'MHHC', :description => 'Health Check', :fee => 50.63, :gl_account_no => '1800-00'
    FeeSchedule.create_with_id 1802, :programme_id => 18, :code => 'MHHO', :description => 'Handover', :fee => 36.00, :gl_account_no => '1800-00'
    
  end

  def self.down
  end
end
