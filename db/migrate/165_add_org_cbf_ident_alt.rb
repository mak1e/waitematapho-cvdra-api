class AddOrgCbfIdentAlt < ActiveRecord::Migration
  def self.up
    add_column :organisations, :cbf_ident_alt, :string, :limit => 16
  end

  def self.down
  end
end
