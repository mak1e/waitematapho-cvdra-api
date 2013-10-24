class AddAdminUser < ActiveRecord::Migration
  def self.up
    # Add an system admin user
    u=User.new
    u.username = 'admin'
    u.password = 'masterkey0'
    u.password_confirm = u.password
    u.role_system_admin = true
    u.save
  end

  def self.down
  end
end
