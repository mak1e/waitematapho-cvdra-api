class CreateEthnicities < ActiveRecord::Migration
  def self.up
    create_table :ethnicities do |t|
      t.string "description", :limit => 35, :null => false
      t.integer "level1_ethnicity_id", :null => false
      t.timestamps
    end
    
    Ethnicity.create_with_id 10, :description => 'European NFD', :level1_ethnicity_id => 1
    Ethnicity.create_with_id 11, :description => 'NZ European', :level1_ethnicity_id => 1
    Ethnicity.create_with_id 12, :description => 'Other European', :level1_ethnicity_id => 1
    Ethnicity.create_with_id 21, :description => 'Maori', :level1_ethnicity_id => 2
    Ethnicity.create_with_id 30, :description => 'Pacific Island NFD', :level1_ethnicity_id => 3
    Ethnicity.create_with_id 31, :description => 'Samoan', :level1_ethnicity_id => 3
    Ethnicity.create_with_id 32, :description => 'Cook Island Maori', :level1_ethnicity_id => 3
    Ethnicity.create_with_id 33, :description => 'Tongan', :level1_ethnicity_id => 3
    Ethnicity.create_with_id 34, :description => 'Niuean', :level1_ethnicity_id => 3
    Ethnicity.create_with_id 35, :description => 'Tokelauan', :level1_ethnicity_id => 3
    Ethnicity.create_with_id 36, :description => 'Fijian', :level1_ethnicity_id => 3
    Ethnicity.create_with_id 37, :description => 'Other Pacific', :level1_ethnicity_id => 3
    Ethnicity.create_with_id 40, :description => 'Asian NFD', :level1_ethnicity_id => 4
    Ethnicity.create_with_id 41, :description => 'South East Asian', :level1_ethnicity_id => 4
    Ethnicity.create_with_id 42, :description => 'Chinese', :level1_ethnicity_id => 4
    Ethnicity.create_with_id 43, :description => 'Indian', :level1_ethnicity_id => 4
    Ethnicity.create_with_id 44, :description => 'Other Asian', :level1_ethnicity_id => 4
    Ethnicity.create_with_id 51, :description => 'Middle Eastern', :level1_ethnicity_id => 5
    Ethnicity.create_with_id 52, :description => 'Latin American', :level1_ethnicity_id => 5
    Ethnicity.create_with_id 53, :description => 'African', :level1_ethnicity_id => 5
    Ethnicity.create_with_id 54, :description => 'Other', :level1_ethnicity_id => 5
    
  end

  def self.down
    drop_table :ethnicities
  end
end
