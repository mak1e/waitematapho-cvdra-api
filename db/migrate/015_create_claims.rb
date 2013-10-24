class CreateClaims < ActiveRecord::Migration
  def self.up
    create_table :claims do |t|
      t.date "invoice_date", :null => false
      t.string "invoice_no", :limit => 18
      
      t.date "date_lodged", :null => false
      t.date "date_service", :null => false
      
      t.integer "patient_id", :null => false
      t.integer "programme_id", :null => false
      t.integer "fee_schedule_id", :null => false
      t.decimal "amount", :precision => 8, :scale => 2
      
      t.integer "organisation_id", :null => false
      t.integer "host_provider_id"
      t.integer "service_provider_id"
      
      t.text "clinical_information"
      
      t.string "comment", :limit => 78 # Reason for rejection. etc 
      
      t.integer "claim_status_id", :default => 5, :null => false
      t.integer "payment_run_id", :default => 0, :null => false
      
      t.integer "cost_organisation_id", :null => false # Allocate expenditure/cost to this organisation
      t.timestamps
    end
    add_index :claims, [:programme_id,:date_service]
    add_index :claims, [:patient_id,:invoice_date]
    add_index :claims, [:payment_run_id,:organisation_id]
    add_index :claims, [:payment_run_id,:programme_id]
    add_index :claims, [:organisation_id,:invoice_date]
    add_index :claims, [:cost_organisation_id,:invoice_date]
    add_index :claims, [:claim_status_id,:updated_at]
  end


  def self.down
    drop_table :claims
  end
end
