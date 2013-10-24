class AddPatientEthnicity2 < ActiveRecord::Migration
  def self.up
    add_column :patients, :ethnicity_2_id, :integer
    add_column :patients, :ethnicity_3_id, :integer
  end

  def self.down
    remove_column :patients, :ethnicity_2_id
    remove_column :patients, :ethnicity_3_id
  end
end
