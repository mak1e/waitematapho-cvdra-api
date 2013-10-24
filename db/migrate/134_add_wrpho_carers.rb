class AddWrphoCarers < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :demen_dementia, :string, :limit => 18
    ClaimsData.reset_column_information
    DataField.populate_table
    
    
    if ( Settings.database =~ /wrpho|phocm/ )
      puts "Whanganui PHO - Carer Relief Day Support"
      
      Programme.create_with_id 43, :code => 'CRDS', :description => 'Carer Relief Day Support'
      
      FeeSchedule.create_with_id 4300, :programme_id => 43, :code => 'CR', :description => 'Carer Relief', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      ProgrammeElement.populate(43, [ 
                    { :position => 0, :column_name => 'demen_dementia'}])
          
    end    
  end

  def self.down
  end
end
