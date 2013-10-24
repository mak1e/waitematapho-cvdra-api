class FixLenDataGld < ActiveRecord::Migration
  def self.up
      change_column :claims_data, :gld_genetic_lipid_disorder, :string, :limit => 40
  end

  def self.down
  end
end
