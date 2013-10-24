class AddHhEtherapy < ActiveRecord::Migration
  def self.up
    
    add_column :claims_data, :mhgad7_mhealth_gad_7, :integer
    add_column :claims_data, :etcon_e_therapy_condition, :string, :limit => 18


    ClaimsData.reset_column_information
    DataField.populate_table
    choices = [
        ['etcon_e_therapy_condition', 
           "GAD\r\nDepression\r\nPanic Disorder\r\nSocial Phobia\r\nOther"]]
    choices.each do |choice|
        df=DataField.find_by_column_name(choice[0]);
        raise ArgumentError, "Data field not found '#{choice[0]}'"  if !df
        df.choices = choice[1];
        df.save!
    end
    
    
    if ( Settings.database =~ /hhcm|phocm/ )
      puts "e-Therapy - Harbour Health"
      
      Programme.create_with_id 28, :code => 'ETHR', :description => 'E-Therapy'
      
      FeeSchedule.create_with_id 2800, :programme_id => 28, :code => 'ENR', :description => 'Enrollment', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0, :is_the_default => true
      FeeSchedule.create_with_id 2801, :programme_id => 28, :code => 'INC', :description => 'In-Complete', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 0, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 1, :is_a_dnr_service => 0, :is_the_default => false
      FeeSchedule.create_with_id 2802, :programme_id => 28, :code => 'INE', :description => 'Ineffectual', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 0, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0, :is_the_default => false
      FeeSchedule.create_with_id 2803, :programme_id => 28, :code => 'COMP', :description => 'Complete', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 0, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0, :is_the_default => false

      FeeSchedule.create_with_id 2809, :programme_id => 28, :code => 'DECL', :description => 'Declined', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 0, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 1, :is_a_dnr_service => 0, :is_the_default => false
        
      ProgrammeElement.populate( 28, [ 
                  { :position => 0, :column_name => 'etcon_e_therapy_condition'},
                  
                  { :position => 4, :column_name => 'mhgad7_mhealth_gad_7'},
                  { :position => 5, :column_name => 'mhk10_mhealth_kessler_10'},
                  { :position => 6, :column_name => 'mhphq9_mhealth_phq_9'},
                  
                  { :position => 8, :column_name => 'nosess_number_of_sessions'}
                  ] )
          
    end
  end

  def self.down
    remove_column :claims_data, :mhgad7_mhealth_gad_7
    remove_column :claims_data, :etcon_e_therapy_condition
    
    Programme.delete_all( 'id = 28' )
    FeeSchedule.delete_all( 'programme_id = 28' )
    
  end
end
