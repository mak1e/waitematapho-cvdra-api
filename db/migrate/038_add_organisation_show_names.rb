class AddOrganisationShowNames < ActiveRecord::Migration
  def self.up
    add_column :organisations, :show_names, :boolean, :default => false, :null => false
  end

  def self.down
  end
end
