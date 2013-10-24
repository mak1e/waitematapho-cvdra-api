class AddGlSupplier < ActiveRecord::Migration
  def self.up
    
    puts "GL Supplier Codes, Change bank_ac_no -> supplier_code"
    
    add_column :organisations, :supplier_code, :string, :limit => 14
    add_column :providers, :supplier_code, :string, :limit => 14

    add_column :organisations, :gl_cost_centre, :string, :limit => 18
    # add_column :organisations, :gl_account_no_merge, :string, :limit => 8 # Old-name
    # add_column :organisations, :gl_account_no_prefix, :string, :limit => 8 # Old-name
    
    Organisation.reset_column_information
    Organisation.update_all("supplier_code = LEFT(bank_ac_no,14)")
    Provider.reset_column_information
    Provider.update_all("supplier_code = LEFT(bank_ac_no,14)")
    
    change_column :fee_schedules, :gl_account_no, :string, :limit => 18
    
    # remove_column :organisations, :bank_ac_no # Retain incase mess-up
    # remove_column :providers, :bank_ac_no
    
  end
  
  def self.down
    # remove_column :organisations, :gl_account_no_merge
    # remove_column :organisations, :gl_account_no_prefix
    remove_column :organisations, :supplier_code
    remove_column :organisations, :gl_cost_centre
    remove_column :providers, :supplier_code
  end
  #  remove_column :organisations, :gl_account_no_merge
  #  add_column :organisations, :gl_cost_centre, :string, :limit => 18
end
