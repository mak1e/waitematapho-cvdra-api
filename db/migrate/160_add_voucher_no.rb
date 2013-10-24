class AddVoucherNo < ActiveRecord::Migration
  def self.up
    puts "Add Voucher (or Claim) Number to data"
    add_column :claims_data, :vono_voucher_no, :string, :limit => 18
    
    ClaimsData.reset_column_information
    DataField.populate_table
  end

  def self.down
    remove_column :claims_data, :vono_voucher_no
    ClaimsData.reset_column_information
    DataField.populate_table
  end
end
