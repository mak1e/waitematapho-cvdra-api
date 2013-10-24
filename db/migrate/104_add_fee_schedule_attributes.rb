class AddFeeScheduleAttributes < ActiveRecord::Migration
  def self.up
    add_column :fee_schedules, :is_a_declined_service, :integer, :null => false, :default => 0
    add_column :fee_schedules, :is_a_dnr_service, :integer, :null => false, :default => 0
    
    FeeSchedule.reset_column_information
    
    if Programme.exists?(3)
      puts "Adding Diabetes declined to fee schedule"
      FeeSchedule.create_with_id 39, :programme_id => 3, :code => 'DIDC',
        :description => 'Diabetes Declined',:fee => 0.00, :gl_account_no => '00-0000'
    end
    FeeSchedule.update_all("is_a_exit_service = 1, is_a_declined_service = 1","id in (39,69,2102,2111)")
    FeeSchedule.update_all("is_a_exit_service = 1, is_a_dnr_service = 1","id in (39,69,2101)")
  end

  def self.down
    remove_column :fee_schedules, :is_a_declined_service
    remove_column :fee_schedules, :is_a_dnr_service
    FeeSchedule.delete [39] if FeeSchedule.exists?(39)
    
  end
end
