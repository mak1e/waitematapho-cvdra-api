class AddWphoPhogc < ActiveRecord::Migration
  def self.up
    
  if ( Settings.database =~ /hhcm|phocm_development/ )
  
#    add_column :claims_data, :cbDiscretion, :string, :limit => 48
     
#    ClaimsData.reset_column_information
#    DataField.populate_table

    
      puts "PHOGC - PHO General Claim"
      
      Programme.create_with_id 10, :code => 'PHOGC', :description => 'PHO General Claim'
      
      FeeSchedule.create_with_id 1001, :programme_id => 10, :code => 'PHOGC', :description => 'PHO General Claim', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
#      ProgrammeElement.populate(**, [
#          { :position => 0,  :column_name => 'cbDiscretion'} 
#        ]);
        
  end

  end

  def self.down
    
    if ( Settings.database =~ /hhcm|phocm_development/ )

      # remove_column :claims_data, :smstatus
  
      Programme.delete_all( 'id = 10' )
      FeeSchedule.delete_all( 'programme_id = 10' )

    end
  end
end