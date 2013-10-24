class AddClaimIndexes < ActiveRecord::Migration
  def self.up
        execute "drop index claims.index_claims_on_payment_run_id_and_organisation_id"
        add_index :claims, [:payment_run_id,:organisation_id,:programme_id]
        add_index :claims, [:payment_run_id,:cost_organisation_id,:programme_id]
        
        add_index :budgets, [ :organisation_id ]
  end

  def self.down
  end
end
