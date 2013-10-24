class AddWelldCplus < ActiveRecord::Migration
  def self.up
    # ActiveRecord::Base.connection.current_database
    Programme.create_with_id 16, :code => 'CPWD', :description => 'Care Plus Well Dunedin'
    
    FeeSchedule.create_with_id 1600, :programme_id => 16, :code => 'CPR', :description => 'Care Plus Review', :fee => 50.00, :gl_account_no => '6400-56', :is_the_default => true
    FeeSchedule.create_with_id 1601, :programme_id => 16, :code => 'CPN', :description => 'Care Plus Non-Funded', :fee => 0.00, :gl_account_no => ''
  end

  def self.down
    Programme.delete_all( 'id = 16')
    FeeSchedule.delete_all( 'programme_id = 16')     
    ProgrammeElement.delete_all( 'programme_id = 16')    
    
  end
end
