class CreatePaymentRuns < ActiveRecord::Migration
  def self.up
    create_table :payment_runs do |t|
      t.date "cut_off_date", :null => false
      
      t.date "payment_date"
      
      t.integer "user_id", :null => false
      t.integer "programme_id", :null => false
      
      t.string "note", :limit => 18
      t.timestamps
    end
    
    # Payment 1 is reserved, for uncommited-run
    PaymentRun.create_with_id 1, :cut_off_date => Date.new(2000,1,1), :user_id => 1, :programme_id => 0, :note => 'un-commited'
    PaymentRun.delete(1)
  end

  def self.down
    drop_table :payment_runs
  end
end
