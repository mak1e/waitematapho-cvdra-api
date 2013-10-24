class CreateProviders < ActiveRecord::Migration
  def self.up
    create_table :providers do |t|
      t.string "registration_no", :limit => 8, :null => false
      
      t.string "name", :limit => 40, :null => false
      
      t.integer "organisation_id", :null => false
      
      t.string  "external_ident", :limit => 18
      
      t.string "bank_ac_no", :limit => 20
      t.string "gst_no", :limit => 10
      
      t.boolean "deleted", :default => false, :null => false
      t.timestamps
    end
    
  end

  def self.down
    drop_table :providers
  end
end
