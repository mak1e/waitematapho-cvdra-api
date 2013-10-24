class AddAutCvd < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /hhcm|phocm/ )
      puts "Adding AUT CVD"
      
      FeeSchedule.create_with_id 27, :programme_id => 2, :code => 'AUCVD', 
          :description => 'AUT CVD Risk', :fee => 55.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 28, :programme_id => 2, :code => 'AUFUP', 
          :description => 'AUT Follow Up', :fee => 70.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 29, :programme_id => 2, :code => 'AUFIN', 
          :description => 'AUT Final', :fee => 70.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
    end
  end

  def self.down
  end
end
