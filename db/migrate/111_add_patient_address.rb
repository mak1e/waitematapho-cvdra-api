class AddPatientAddress < ActiveRecord::Migration
  def self.up
    add_column :patients, :street, :string, :limit => 45
    add_column :patients, :suburb, :string, :limit => 30
    add_column :patients, :city, :string, :limit => 30
    add_column :patients, :post_code, :string, :limit => 10
    
    add_column :patients, :phone, :string, :limit => 14
    
    add_column :users, :show_name_address_csv, :boolean, :null => false, :default => 0 # Show Name/Address csv
  end

  def self.down
    remove_column :patients, :street
    remove_column :patients, :suburb
    remove_column :patients, :city
    remove_column :patients, :post_code
    
    remove_column :patients, :phone
    
    remove_column :users, :show_name_address_csv
  end
end
