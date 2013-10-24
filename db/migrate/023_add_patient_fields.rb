class AddPatientFields < ActiveRecord::Migration
  def self.up
    add_column :patients, :organisation_id, :integer
  end

  def self.down
  end
end
