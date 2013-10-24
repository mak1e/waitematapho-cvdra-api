class RemoveProgrammeElementCols < ActiveRecord::Migration
  def self.up
    # NOTE: remove_columns in not implemented in SQLServer so use remove_column
    remove_column :programme_elements, :description
    remove_column :programme_elements, :data_type
    remove_column :programme_elements, :limit
    remove_column :programme_elements, :choices
    
    execute "update programme_elements\n"+
            "set position = ( select count(id) \n"+
            "             from programme_elements e \n"+
            "             where e.programme_id = programme_elements.programme_id \n"+
            "               and (e.position < programme_elements.position or\n"+
            "                    (e.position = programme_elements.position and \n"+
            "                     e.column_name < programme_elements.column_name)))";

    # Reserve the 1st 32 programmes 
    Programme.create_with_id 32, :code => 'RES', :description => 'Reserved'
    Programme.find(32).destroy
    
    # Reserve the 1st 128 fee schedules
    FeeSchedule.create_with_id 128, :programme_id => 1, :code => 'RES', :description => 'Reserved', :gl_account_no => '000000'
    FeeSchedule.find(128).destroy
    
  end

  def self.down
  end

end
