class ModifyCareplus < ActiveRecord::Migration
  def self.up
    add_column :patients, 'is_care_plus', :integer, :null => false, :default => 0
    Patient.update_all( 'is_care_plus = 1', 'careplus =  1');
    remove_column :patients, 'careplus'
  end

  def self.down
  end
end
