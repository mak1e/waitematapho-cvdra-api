class AddBetterWork < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /hhcm|phocm/ )
      puts "Adding Better @ Work"
      

      # Diabetes Self Management Education for Harbour Health
      Programme.create_with_id 24, :code => 'B@W', :description => 'Better @ Work'
      
      FeeSchedule.create_with_id 2400, :programme_id => 24, :code => 'B@WR', :description => 'Referral', :fee => 50.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 2401, :programme_id => 24, :code => 'B@WN', :description => 'Notification', :fee => 50.00, :gl_account_no => '0000-00', 
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
    end
    
  end

  def self.down
    Programme.delete_all( 'id = 24' )
    FeeSchedule.delete_all( 'programme_id = 24' )
  end
end
