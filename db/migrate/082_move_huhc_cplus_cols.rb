class MoveHuhcCplusCols < ActiveRecord::Migration
  def self.up
    remove_column :claims_data, :cplus_cplus_enrolled
    remove_column :claims_data, :huhc_huhc_holder
    ClaimsData.reset_column_information
    DataField.populate_table        
    
    add_column :claims, :cplus_enrolled, :integer
    add_column :claims, :huhc_holder, :integer
  end

  def self.down
    add_column :claims_data, :cplus_cplus_enrolled, :boolean
    add_column :claims_data, :huhc_huhc_holder, :boolean
    ClaimsData.reset_column_information
    DataField.populate_table       
    
    remove_column :claims, :cplus_enrolled
    remove_column :claims, :huhc_holder
  end
end
