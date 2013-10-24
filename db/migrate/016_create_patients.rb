class CreatePatients < ActiveRecord::Migration
  def self.up
    create_table :patients do |t|
      t.string "nhi_no", :limit => 7
     
      t.string "family_name", :limit => 40, :null => false
      t.string "given_names", :limit => 40
      t.date "date_of_birth"
      t.string "gender_id", :limit => 1
      t.integer "ethnicity_id"
      t.integer "quintile"
      t.string "dhb_id", :limit => 3
    
      t.string "comment", :limit => 78
      
      t.boolean "careplus", :default => false, :null => false
      
      t.boolean "deleted", :default => false, :null => false
      
      t.timestamps
    end
    
    add_index :patients, :nhi_no
    add_index :patients, :family_name    
    
  end

  def self.down
    drop_table :patients
  end
end
