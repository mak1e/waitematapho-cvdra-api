class AddHuhcCplusData < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :cplus_cplus_enrolled, :boolean
    add_column :claims_data, :huhc_huhc_holder, :boolean
    ClaimsData.reset_column_information
    
    DataField.populate_table    
  end

  def self.down
    remove_column :claims_data, :cplus_cplus_enrolled
    remove_column :claims_data, :huhc_huhc_holder
    ClaimsData.reset_column_information
    
    DataField.populate_table    
  end
end
