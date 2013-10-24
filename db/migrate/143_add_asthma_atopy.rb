class AddAsthmaAtopy < ActiveRecord::Migration
  def self.up
    puts "Adding Asthma New Fields"
    add_column :claims_data, :trgmold_trigger_mould_damp, :boolean
    add_column :claims_data, :fhato_fh_atopy, :boolean
    add_column :claims_data, :sinu_sinusitis, :boolean
  end

  def self.down
  end
end
