class CreateAccessLogs < ActiveRecord::Migration
  def self.up
    create_table :access_logs do |t|
      t.integer "user_id", :null => false
      t.integer "patient_id", :null => false
      t.integer "claim_id"
      t.timestamp "created_at", :null => false
    end
    add_index :access_logs, [ :patient_id, :id ]
  end

  def self.down
    drop_table :access_logs
  end
end
