class AddB4scDeclined < ActiveRecord::Migration
  def self.up
    
    require "db/migrate/045_add_b4sc_choices.rb"
    
    AddB4scChoices.up
    
    FeeSchedule.create_with_id 69, :programme_id => 6, :code => 'B4SCDC', :description => 'Declined', :fee => 0, :gl_account_no => '6-0000'
    
  end

  def self.down
  end
end
