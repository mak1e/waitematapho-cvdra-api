class AddDataCondition < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :cond_condition, :string, :limit => 28
    add_column :claims_data, :conr_condition_read, :string, :limit => 8
    add_column :claims_data, :dod_date_of_death, :date
  end

  def self.down
    remove_column :claims_data, :cond_condition
    remove_column :claims_data, :conr_condition_read
    remove_column :claims_data, :dod_date_of_death
  end
end
