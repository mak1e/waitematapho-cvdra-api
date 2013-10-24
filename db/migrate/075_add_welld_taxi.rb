class AddWelldTaxi < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :taoby_taxi_ordered_by, :string, :limit => 18
    add_column :claims_data, :tapos_taxi_position, :string, :limit => 18
    add_column :claims_data, :tapur_taxi_purpose, :string, :limit => 28
    add_column :claims_data, :tapuo_taxi_purpose_other, :string, :limit => 18
    
    ClaimsData.reset_column_information
    DataField.populate_table    

    Programme.create_with_id 13, :code => 'TAXI', :description => 'Transport Authorisation'
    
    FeeSchedule.create_with_id 1300, :programme_id => 13, :code => 'TAU', :description => 'Transport Authorisation', :fee => 0.00, :gl_account_no => '13-0000', :is_the_default => true
    FeeSchedule.create_with_id 1301, :programme_id => 13, :code => 'TPA', :description => 'Transport Payment', :fee => 0.00, :gl_account_no => '13-0001'
    
    choices = [
        ['tapur_taxi_purpose', "GP Visit\r\nUrgent Secondary Care\r\nRoutine Secondary Care\r\nOther"]]
    
    choices.each do |choice|
        df=DataField.find_by_column_name(choice[0]);
        raise ArgumentError, "Data field not found '#{choice[0]}'"  if !df
        df.choices = choice[1];
        df.save!
     end
    
    ProgrammeElement.populate(13, [ 
                  { :position => 0,  :column_name => 'taoby_taxi_ordered_by'},
                  { :position => 1,  :column_name => 'tapos_taxi_position'},
                  
                  { :position => 4,  :column_name => 'tapur_taxi_purpose'},
                  { :position => 5,  :column_name => 'tapuo_taxi_purpose_other'}])
    
    
  end

  def self.down
    remove_column :claims_data, :taoby_taxi_ordered_by
    remove_column :claims_data, :tapos_taxi_position
    remove_column :claims_data, :tapur_taxi_purpose
    remove_column :claims_data, :tapuo_taxi_purpose_other
    ClaimsData.reset_column_information
    DataField.populate_table    
    Programme.delete_all( 'id = 13')
    FeeSchedule.delete_all( 'programme_id = 13')  
    ProgrammeElement.delete_all( 'programme_id = 13')    
    
    
  end
end
