class CreateCarePlusCriterias < ActiveRecord::Migration
  def self.up
    create_table :care_plus_criterias do |t|
      t.string :description, :limit => 28, :null => false
      t.integer :position, :null => false, :default => 0      
    end
    add_column :patients, :care_plus_criteria_id, :integer
    add_column :patients, :care_plus_criteria_2_id, :integer
    add_column :patients, :care_plus_criteria_3_id, :integer
    add_column :patients, :care_plus_criteria_4_id, :integer
    
    add_column :patients, :care_plus_condition, :string, :limit => 18
    add_column :patients, :care_plus_condition_2, :string, :limit => 18
    add_column :patients, :care_plus_condition_3, :string, :limit => 18
    add_column :patients, :care_plus_condition_4, :string, :limit => 18
    
    CarePlusCriteria.create_with_id  2, :description => '6+ Visits/6 Months'
    CarePlusCriteria.create_with_id  3, :description => '3+ Admits/12 Months'
    CarePlusCriteria.create_with_id  4, :description => 'Terminal Illness'
    CarePlusCriteria.create_with_id  5, :description => '2+ Chronic Conditions'
    CarePlusCriteria.create_with_id  6, :description => 'Elective Services'
    
    CarePlusCriteria.update_all('position = id');
    
  end

  def self.down
    drop_table :care_plus_criterias
  end
end
