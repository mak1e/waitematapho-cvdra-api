class ReindexClaims < ActiveRecord::Migration
  def self.up
    remove_index "claims", "payment_run_id_and_organisation_id_and_programme_id"
   
    add_index "claims", ["payment_run_id", "organisation_id", "programme_id","invoice_date"], :name => "payment_run_organisation_programme_date"
  end
  
  def self.down
  end
end
