class RedoHhDsme < ActiveRecord::Migration
  def self.up
    remove_column :fee_schedules, :triggers_a_followup
    remove_column :fee_schedules, :is_a_followup_service
    puts "Adding service reminders"
    add_column :fee_schedules, :reminder_on, :boolean, :null => false, :default => false
    add_column :fee_schedules, :reminder_in_weeks, :integer
    add_column :fee_schedules, :reminder_note, :string, :limit => 78
    FeeSchedule.reset_column_information

    if ( Programme.exists?(21) )
      puts "Updating DSME Service options (hhealth)"
     
      FeeSchedule.delete_all( 'programme_id = 21' )
      ProgrammeElement.delete_all( 'programme_id = 21' )
      
      FeeSchedule.create_with_id 2100, :programme_id => 21, :code => 'DSINV', :description => 'Invite', :fee => 0.00, :gl_account_no => '0000-00', :is_the_default => true, :is_a_entry_service => 1, :is_a_exit_service => 0,
         :reminder_on => true, :reminder_in_weeks => 4, :reminder_note => 'No response to invite'
      FeeSchedule.create_with_id 2101, :programme_id => 21, :code => 'DSNOR', :description => 'Non Responder', :fee => 0.00, :gl_account_no => '0000-00', :is_a_exit_service  => 1, :is_a_entry_service => 0
      FeeSchedule.create_with_id 2102, :programme_id => 21, :code => 'DSDEC', :description => 'Declined', :fee => 0.00, :gl_account_no => '0000-00', :is_a_exit_service  => 1, :is_a_entry_service => 0
      FeeSchedule.create_with_id 2103, :programme_id => 21, :code => 'DSREM', :description => 'Reminder', :fee => 0.00, :gl_account_no => '0000-00', :is_a_exit_service  => 0, :is_a_entry_service => 0,
         :reminder_on => true, :reminder_in_weeks => 4, :reminder_note => 'No response to reminder'

      FeeSchedule.create_with_id 2104, :programme_id => 21, :code => 'DSSESS', :description => 'Session', :fee => 0.00, :gl_account_no => '0000-00', :is_a_exit_service  => 0, :is_a_entry_service => 0,
         :reminder_on => true, :reminder_in_weeks => 4, :reminder_note => 'Not complete after session(s)'
      FeeSchedule.create_with_id 2105, :programme_id => 21, :code => 'DSDIET', :description => 'Dietician', :fee => 0.00, :gl_account_no => '0000-00', :is_a_exit_service  => 0, :is_a_entry_service => 0,
         :reminder_on => true, :reminder_in_weeks => 4, :reminder_note => 'Not complete after dietician'
      FeeSchedule.create_with_id 2106, :programme_id => 21, :code => 'DSAPP', :description => 'Appointment Booked', :fee => 0.00, :gl_account_no => '0000-00', :is_a_exit_service  => 0, :is_a_entry_service => 0,
         :reminder_on => true, :reminder_in_weeks => 1, :reminder_note => 'No details recorded after appointment'
      
      FeeSchedule.create_with_id 2107, :programme_id => 21, :code => 'DSINCO', :description => 'In Complete', :fee => 0.00, :gl_account_no => '0000-00', :is_a_exit_service  => 1, :is_a_entry_service => 0
      FeeSchedule.create_with_id 2108, :programme_id => 21, :code => 'DSCOMP', :description => 'Complete', :fee => 0.00, :gl_account_no => '0000-00', :is_a_exit_service  => 1, :is_a_entry_service => 0,
         :reminder_on => true, :reminder_in_weeks => 12, :reminder_note => 'Follow up required'
      
      FeeSchedule.create_with_id 2110, :programme_id => 21, :code => 'DSFUP', :description => 'Follow-up', :fee => 0.00, :gl_account_no => '0000-00', :is_a_exit_service  => 0, :is_a_entry_service => 0
      FeeSchedule.create_with_id 2111, :programme_id => 21, :code => 'DSNFU', :description => 'No Follow-up', :fee => 0.00, :gl_account_no => '0000-00', :is_a_exit_service  => 0, :is_a_entry_service => 0

    end
    
  
    if ( FeeSchedule.exists?(30) ) # Diabetes Annual Review
       f=FeeSchedule.find(30);
       f.reminder_on = true
       f.reminder_in_weeks = 60
       f.reminder_note = 'Diabetes annual review is overdue'
       f.save!
    end
  end

  def self.down
    add_column :fee_schedules, :triggers_a_followup, :integer, :default => 0
    add_column :fee_schedules, :is_a_followup_service, :integer, :default => 0
    remove_column :fee_schedules, :reminder_on
    remove_column :fee_schedules, :reminder_in_weeks
    remove_column :fee_schedules, :reminder_note
  end
end
