class AddNotGstRegistered < ActiveRecord::Migration
  def self.up
    add_column :organisations, :not_gst_registered, :boolean, :default => false, :null => false
  end

  def self.down
  end
end
