class AddWaioraSmear < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /waiora|phocm/ )
      puts "WAIORA - Smear - Cervical Screening"
      
      Programme.create_with_id 27, :code => 'CXSM', :description => 'Cervical Screening'
      
      FeeSchedule.create_with_id 2700, :programme_id => 27, :code => 'COMP', :description => 'Completed', :fee => 20.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
    end
    
  end

  def self.down
  end
end
