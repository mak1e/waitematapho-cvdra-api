class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
        t.column :username, :string, :limit => 18, :null => false
        t.column :password_salt, :string, :limit => 8, :null => false
        t.column :password_hash, :string,  :limit => 64, :null => false    
        
        t.column :role_system_admin, :boolean, :null => false, :default => 0 # System admin (add users etc)
        t.column :role_claims_admin, :boolean, :null => false, :default => 0 # Claims Administrator (add programmes/fees etc)
        t.column :role_claims_processing, :boolean, :null => false, :default => 0 # Claims Administrator (add/edit accept/reject claims)
        t.column :role_payment_processing, :boolean, :null => false, :default => 0 # Payment Processing (payment run/undo)

        t.column :last_login_at, :timestamp        
        
        t.column :deleted, :boolean, :null => false, :default => 0
    end
    
  end

  def self.down
  end
end
