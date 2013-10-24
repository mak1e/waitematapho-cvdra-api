class AddHhPcp < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /hhcm|phocm/ )
      puts "Harbour - Palliative Care Project"
      
      Programme.create_with_id 36, :code => 'PCP', :description => 'Palliative Care Project'
      
      FeeSchedule.create_with_id 3600, :programme_id => 36, 
          :code => 'PCIV', :description => 'Initial Visit', :fee => 150.00, 
          :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      FeeSchedule.create_with_id 3601, :programme_id => 36, 
          :code => 'PCPV', :description => 'Practice Visit', :fee => 40.00, 
          :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      FeeSchedule.create_with_id 3602, :programme_id => 36, 
          :code => 'PCHV', :description => 'Home Visit', :fee => 140.00, 
          :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      FeeSchedule.create_with_id 3603, :programme_id => 36, 
          :code => 'PCOV', :description => 'Out of Hours Visit', :fee => 200.00, 
          :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      FeeSchedule.create_with_id 3604, :programme_id => 36, 
          :code => 'PCCP', :description => 'Care Plan Update', :fee => 30.00, 
          :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      FeeSchedule.create_with_id 3605, :programme_id => 36, 
          :code => 'PCCE', :description => 'Case Evaluation', :fee => 50.00, 
          :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      FeeSchedule.create_with_id 3606, :programme_id => 36, 
          :code => 'PCBF', :description => 'Bereavement F-Up', :fee => 40.00, 
          :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      ProgrammeElement.populate(36, [ 
                    { :position => 0,  :column_name => 'cond_condition'} ]);
    end
        
  end

  def self.down
    Programme.delete_all( 'id = 36' )
    FeeSchedule.delete_all( 'programme_id = 36' )
    ProgrammeElement.delete_all( 'programme_id = 36' )
  end
end
