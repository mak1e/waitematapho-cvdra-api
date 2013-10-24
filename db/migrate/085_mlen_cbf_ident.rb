class MlenCbfIdent < ActiveRecord::Migration
  def self.up
      change_column :organisations, :cbf_ident, :string, :limit => 16
      change_column :providers, :cbf_ident, :string, :limit => 16
  end

  def self.down
  end
end
