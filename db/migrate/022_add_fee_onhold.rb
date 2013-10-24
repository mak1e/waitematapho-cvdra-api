class AddFeeOnhold < ActiveRecord::Migration
  def self.up
    add_column :fee_schedules, :on_hold, :boolean, :null => false, :default => 0
  end    


  def self.down
  end
end
