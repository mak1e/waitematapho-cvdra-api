class CreateBudgets < ActiveRecord::Migration
  def self.up
    create_table :budgets do |t|
      t.integer "programme_id", :null => false
      t.integer "organisation_id", :null => false
      
      t.decimal "budget", :precision => 8, :scale => 0
    end
    add_index :budgets, [ :programme_id, :organisation_id ]
    
    add_column :programmes, 'commit_episode', :decimal,  :precision => 8, :scale => 2
    add_column :programmes, 'drs_revence_episode', :decimal,  :precision => 8, :scale => 2
    
    add_column :programmes, 'budget_start', :date
    add_column :programmes, 'budget_method', :string,  :limit => 1
    add_column :programmes, 'budget_wording', :string,  :limit => 18
    add_column :programmes, 'budget_details', :string,  :limit => 78
    add_column :programmes, 'budget_internal_only', :boolean
    
    add_column :programmes, 'detail_payments_other', :boolean
    
    add_column :fee_schedules, 'episode_care', :integer, :default => 1
    
    FeeSchedule.update_all('episode_care = 1')
    
  end
  
  def self.down
    drop_table :budgets
  end
end

#select o.name, b.qty, b.amount, sum(c.amount)
#from claims c
#  left join organisations o on o.id = c.cost_organisation_id
#  left join budgets b on b.programme_id = c.programme_id and b.organisation_id = c.cost_organisation_id
#where c.invoice_date > '20080601' and c.programme_id = 2
#and (c.claim_status_id = 5 or c.claim_status_id = 6)
#group by o.name, b.qty, b.amount
#order by o.name


