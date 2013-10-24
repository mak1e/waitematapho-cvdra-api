class AddWelldMcvdm < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :canut_nutrition, :boolean
    ClaimsData.reset_column_information
    DataField.populate_table
    
    if ( Settings.database =~ /welldun|phocm/ )
      # Add Mens CVD Management for Well Dunedin
      Programme.create_with_id 19, :code => 'MCVDM', :description => 'Mens CVD Management'
      
      FeeSchedule.create_with_id 1900, :programme_id => 19, :code => 'MCVDI', :description => 'Initial', :fee => 80.00, :gl_account_no => '6409-74', :is_the_default => true
      FeeSchedule.create_with_id 1901, :programme_id => 19, :code => 'MCVDF', :description => 'Follow-up', :fee => 30.00, :gl_account_no => '6409-74'
      
      ProgrammeElement.populate(19, [ 
                    { :position => 0,  :column_name => 'canex_nutrition_exercise'},
                    { :position => 1,  :column_name => 'canut_nutrition'},
                    { :position => 2,  :column_name => 'camedi_medications'},
                    { :position => 3,  :column_name => 'casmk_smoking'},
                    { :position => 4,  :column_name => 'caohn_other_heath_need'} ])
      
      
    end
  end

  def self.down
    remove_column :claims_data, :canut_nutrition
    Programme.delete_all( 'id = 19')
    FeeSchedule.delete_all( 'programme_id = 19')    
    ProgrammeElement.delete_all( 'programme_id = 19')    
  end
end
