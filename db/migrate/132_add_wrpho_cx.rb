class AddWrphoCx < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :prio_priority_level, :string, :limit => 30
    ClaimsData.reset_column_information
    DataField.populate_table
    
    
    if ( Settings.database =~ /wrpho|phocm/ )
      puts "Whanganui PHO - Smear - Cervical Screening"
      
      Programme.create_with_id 41, :code => 'CXP', :description => 'Cervical Screening'
      
      FeeSchedule.create_with_id 4100, :programme_id => 41, :code => 'COMP', :description => 'Completed (No Referral)', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 4101, :programme_id => 41, :code => 'COMPR', :description => 'Completed (Referral)', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 4102, :programme_id => 41, :code => 'PREVCX', :description => 'Data Cleanse (Previous CX)', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      ProgrammeElement.populate(41, [ 
                    { :position => 0, :column_name => 'prio_priority_level'}])
          
    end    
  end
  
  def self.down
  end
end
