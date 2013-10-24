class CreateLevel1Ethnicities < ActiveRecord::Migration
  def self.up
    create_table :level1_ethnicities do |t|
      t.string "description", :limit => 18, :null => false  
      t.timestamps
    end
    Level1Ethnicity.create_with_id 1, :description => 'European'
    Level1Ethnicity.create_with_id 2, :description => 'Maori'
    Level1Ethnicity.create_with_id 3, :description => 'Pacific-I'
    Level1Ethnicity.create_with_id 4, :description => 'Asian'
    Level1Ethnicity.create_with_id 5, :description => 'Other'      
  end

  def self.down
    drop_table :level1_ethnicities
  end
end
