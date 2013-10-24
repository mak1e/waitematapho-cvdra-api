class CreateProgrammes < ActiveRecord::Migration
  def self.up
    create_table :programmes do |t|
      t.string :code, :limit => 8, :null => false
      t.string :description, :limit => 38, :null => false
      t.boolean :deleted, :null => false, :default => 0
      
      t.timestamps
    end
    Programme.create_with_id 1, :code => 'CPLUS', :description => 'Care Plus'
    Programme.create_with_id 2, :code => 'CVDR', :description => 'Cardio Vascular Disease Risk'
    Programme.create_with_id 3, :code => 'DIAB', :description => 'Diabetes'
    Programme.create_with_id 4, :code => 'ASTH', :description => 'Asthma'
    Programme.create_with_id 5, :code => 'SIA', :description => 'SIA'
  end

  def self.down
    drop_table :programmes
  end
end
