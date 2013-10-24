class AddSettingsImporturl < ActiveRecord::Migration
  def self.up
    add_column :settings,  :hlink_importer_url, :string, :limit => 78
  end

  def self.down
  end
end
