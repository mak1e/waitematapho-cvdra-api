class AddWelldPalc < ActiveRecord::Migration
  def self.up

    ClaimsData.reset_column_information
    DataField.populate_table    

    Programme.create_with_id 17, :code => 'PALC', :description => 'Palliative Care Visit'
    
    FeeSchedule.create_with_id 1700, :programme_id => 17, :code => 'PGPP', :description => 'Pal/C GP at Practice', :fee => 30.00, :gl_account_no => '6400-11', :is_the_default => true
    FeeSchedule.create_with_id 1701, :programme_id => 17, :code => 'PGPH', :description => 'Pal/C GP Home Visit', :fee => 65.00, :gl_account_no => '6400-11'
    FeeSchedule.create_with_id 1702, :programme_id => 17, :code => 'PNUP', :description => 'Pal/C Nurse at Practice', :fee => 0.00, :gl_account_no => '6400-11'
    FeeSchedule.create_with_id 1703, :programme_id => 17, :code => 'PNUH', :description => 'Pal/C Nurse Home Visit', :fee => 0.00, :gl_account_no => '6400-11'
    
    ProgrammeElement.populate(17, [ 
                  { :position => 0,  :column_name => 'cond_condition'},
                  { :position => 1,  :column_name => 'conr_condition_read'},
                  { :position => 4,  :column_name => 'dod_date_of_death'} ] )
    
  end


  def self.down
        
    ClaimsData.reset_column_information
    DataField.populate_table    
    
    Programme.delete_all( 'id = 17')
    FeeSchedule.delete_all( 'programme_id = 17')    
    ProgrammeElement.delete_all( 'programme_id = 17')    
  end
end
