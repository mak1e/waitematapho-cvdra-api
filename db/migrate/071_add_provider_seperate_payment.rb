class AddProviderSeperatePayment < ActiveRecord::Migration
  def self.up
    add_column :providers, :seperate_payment, :boolean  
  end

  def self.down
  end
end
