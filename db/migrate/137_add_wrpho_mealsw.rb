class AddWrphoMealsw < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /wrpho|phocm/ )
      puts "Whanganui PHO - Meals-on-Wheels"
      
      Programme.create_with_id 46, :code => 'MOW', :description => 'Meals-on-Wheels'
      
      FeeSchedule.create_with_id 4600, :programme_id => 46, :code => 'MOW', :description => 'Meals-on-Wheels', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 0,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
    end    

  end

  def self.down
  end
end
