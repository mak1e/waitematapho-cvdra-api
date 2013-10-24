class AddMhealthOutcome < ActiveRecord::Migration
  def self.up
    if ( Programme.exists?(8) )
      FeeSchedule.create_with_id 817, :programme_id => 8, :code => 'PMOUTC', :description => 'Outcome', :fee => 0.00, :gl_account_no => '6-0000',
        :is_a_exit_service => 1, :is_a_entry_service => 0

        
      f=FeeSchedule.find(817)
      f.reminder_on = true
      f.reminder_in_weeks = 1
      f.reminder_note = 'Treatment complete missing'
      f.save!
    end
  end

  def self.down
  end
end
