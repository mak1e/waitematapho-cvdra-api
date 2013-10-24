class AddClaimsDataUnderActiveMgmt < ActiveRecord::Migration
  def self.up
    puts "Active Managment Field"
    add_column :claims_data, :amgmt_under_active_mgmt, :boolean
    
    ClaimsData.reset_column_information
    DataField.populate_table
    
  end

  def self.down
  end
end
