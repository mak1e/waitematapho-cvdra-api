class AddWelldunWd24hrbp < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /welldun|phocm/ )
      puts "WELLDUN - 24 Hour Blood Pressure Monitor"
      
      
      Programme.create_with_id 35, :code => '24HRBP', :description => '24 Hour Blood Pressure Monitor'
      
      FeeSchedule.create_with_id 3500, :programme_id => 35, :code => '24HRBP', :description => '24 hr BP', :fee => 50.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      ProgrammeElement.populate(35, [ 
                    { :position => 0,  :column_name => 'hcra_hcheck_referring_agency'},
                    
                    { :position => 4,  :column_name => 'reffn_referral_from_name'} ]);
    end
    
  end

  def self.down
  end
end
