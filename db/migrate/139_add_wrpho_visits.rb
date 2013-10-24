class AddWrphoVisits < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /wrpho|phocm/ )
      puts "Whanganui PHO - Visiting Service"
      
      Programme.create_with_id 48, :code => 'VIS', :description => 'Visiting Service'
      
      FeeSchedule.create_with_id 4800, :programme_id => 48, :code => 'FV', :description => 'First Visit', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      FeeSchedule.create_with_id 4801, :programme_id => 48, :code => 'FU', :description => 'Follow Up', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      ProgrammeElement.populate(48, [ 
                    { :position => 0, :column_name => 'refft_referral_from_type'},
                    { :position => 1, :column_name => 'cont_contact_type'}])

          
          
    end    
    
  end

  def self.down
  end
end
