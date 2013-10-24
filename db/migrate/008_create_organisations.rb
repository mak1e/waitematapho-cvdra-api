class CreateOrganisations < ActiveRecord::Migration
  def self.up
    create_table :organisations do |t|
      t.string "name", :limit => 40, :null => false
        
      t.integer "pho_id"
      
      t.string "residential_street", :limit => 45
      t.string "residential_suburb", :limit => 30
      t.string "residential_city", :limit => 30
      
      t.string "postal_street", :limit => 45
      t.string "postal_suburb", :limit => 30
      t.string "postal_city", :limit => 30
      t.string "postal_post_code", :limit => 10  
      
      t.string "phone", :limit => 14
      t.string "fax", :limit => 14
      t.string "hlink", :limit => 8
      
      t.string "per_org_id", :limit => 8
      t.string "bank_ac_no", :limit => 20
      t.string "gst_no", :limit => 10

      t.string "comment", :limit => 78
      
      t.integer "est_no_patients"
      
      t.boolean "deleted", :default => false, :null => false
      
      t.timestamps
     end
  end

  def self.down
    drop_table :organisations
  end
end
