class FixupPostal < ActiveRecord::Migration
  def self.up
    execute "update organisations set postal_street = null where residential_street = postal_street"
    execute "update organisations set postal_suburb = null where postal_street is null"
    execute "update organisations set postal_city = null where postal_street is null"
  end

  def self.down
  end
end
