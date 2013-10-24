class AddPatientHuhcHolder < ActiveRecord::Migration
  def self.up
    add_column :patients, :is_huhc_holder, :integer
  end

  def self.down
    remove_column :patients, :is_huhc_holder
  end
end
