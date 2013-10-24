class AddWhangCx < ActiveRecord::Migration
  # Add Whanganiu PHO Care Plus Fields
  def self.up
    Programme.create_with_id 10, :code => 'CX', :description => 'Cervical Screening'
    
    FeeSchedule.create_with_id 1000, :programme_id => 10, :code => 'CXC ', :description => 'CX Claim', :fee => 26.00, :gl_account_no => '10-0000'
  end

  def self.down
    Programme.delete_all( 'id = 10')
    FeeSchedule.delete_all( 'programme_id = 10')
  end
end
