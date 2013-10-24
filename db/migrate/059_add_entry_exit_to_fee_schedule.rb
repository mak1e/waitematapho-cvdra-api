class AddEntryExitToFeeSchedule < ActiveRecord::Migration
  def self.up
    rename_column :fee_schedules, :episode_care, :is_a_entry_service
    add_column :fee_schedules, :is_a_exit_service, :integer, :default => 1
    add_column :fee_schedules, :is_a_practice_service, :integer, :default => 1
  end

  def self.down
    remove_column :fee_schedules, :is_a_practice_service
    remove_column :fee_schedules, :is_a_exit_service
    rename_column :fee_schedules, :is_a_entry_service, :episode_care
  end
end
