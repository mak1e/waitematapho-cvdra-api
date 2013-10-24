class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string "name", :limit => 40, :null => false
        
      t.string "dhb_id", :limit => 3
      
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
      
      t.string "bank_ac_no", :limit => 20
      t.string "gst_no", :limit => 10

      t.string "advice_message", :limit => 78
      
      t.timestamps
    end
    
    Settings.create_with_id 1, :name => 'PHO'
    
  end

  def self.down
    drop_table :settings
  end
end
