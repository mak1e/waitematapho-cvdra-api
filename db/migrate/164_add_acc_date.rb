class AddAccDate < ActiveRecord::Migration
  def self.up
    add_column :claims_data,:accd_acc_accident_date , :date
  end

  def self.down
    remove_column :claims_data,:accd_acc_accident_date
  end
end
