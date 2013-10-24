class AddOrgCbfSupplierCode < ActiveRecord::Migration
  def self.up
    add_column :organisations, :cbf_supplier_code, :string, :limit => 14
  end

  def self.down
    remove_column :organisations, :cbf_supplier_code
  end
end
