class RedoHealthf2Function < ActiveRecord::Migration
  def self.up
    execute "DROP FUNCTION healthf2"
    
    require "db/migrate/036_create_healthf2_function.rb"
    
    CreateHealthf2Function.up
    
  end

  def self.down
  end
end
