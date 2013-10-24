class AddOrganisationsCbf < ActiveRecord::Migration
  def self.up
    add_column :organisations, :cbf_cplus_perage, :decimal, :precision => 5, :scale => 2
    
    add_column :organisations, :cbf_under6_perage, :decimal, :precision => 5, :scale => 2
    add_column :organisations, :cbf_under6_qtrly_payment, :integer
    
    add_column :organisations, :cbf_vcla_perage, :decimal, :precision => 5, :scale => 2
    add_column :organisations, :cbf_vcla_qtrly_payment, :integer
    
    add_column :organisations, :cbf_hp_perage, :decimal, :precision => 5, :scale => 2 # NOT used as yet
    add_column :organisations, :cbf_sia_perage, :decimal, :precision => 5, :scale => 2 # NOT used as yet
    
  end

  def self.down
    remove_column :organisations, :cbf_cplus_perage 
    remove_column :organisations, :cbf_under6_perage
    remove_column :organisations, :cbf_under6_qtrly_payment
    remove_column :organisations, :cbf_vcla_perage
    remove_column :organisations, :cbf_vcla_qtrly_payment
    remove_column :organisations, :cbf_hp_perage
    remove_column :organisations, :cbf_sia_perage
  end
end
