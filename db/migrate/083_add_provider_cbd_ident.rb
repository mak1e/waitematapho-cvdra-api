class AddProviderCbdIdent < ActiveRecord::Migration
  def self.up
    add_column :providers, :cbf_ident, :string, :limit => 8
  end

  def self.down
    remove_column :providers, :cbf_ident
  end
end
