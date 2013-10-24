class AddProgrammeInclZero < ActiveRecord::Migration
  def self.up
    add_column :programmes, :incl_zero_advice, :boolean, :null => false, :default => false # Suppress $0 Invoices on remittance advice
    Programme.reset_column_information
    Programme.update_all('incl_zero_advice = 1')
    
    
  end

  def self.down
    remove_column :programmes, :incl_zero_advice
  end
end
