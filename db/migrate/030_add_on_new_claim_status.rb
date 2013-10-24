class AddOnNewClaimStatus < ActiveRecord::Migration
  def self.up
    add_column :fee_schedules, :on_new_claim_status_id, :integer
    add_column :fee_schedules, :on_new_claim_comment, :string, :limit => 18
    add_column :organisations, :on_new_claim_status_id, :integer
    add_column :organisations, :on_new_claim_comment, :string, :limit => 18
  end

  def self.down
  end
end
