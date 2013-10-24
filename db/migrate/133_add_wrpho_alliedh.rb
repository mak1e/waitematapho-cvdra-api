class AddWrphoAlliedh < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :cont_contact_type, :string, :limit => 28
    add_column :claims_data, :conl_contact_location, :string, :limit => 28
    # change_column :claims_data, :refft_referral_from_type, :string, :limit => 28
    
    ClaimsData.reset_column_information
    DataField.populate_table
    
    
    if ( Settings.database =~ /wrpho|phocm/ )
      puts "Whanganui PHO - Allied Health Services"
      
      Programme.create_with_id 42, :code => 'AHS', :description => 'Allied Health Services'
      
      FeeSchedule.create_with_id 4200, :programme_id => 42, :code => 'OT', :description => 'Occupational Therapist', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 4201, :programme_id => 42, :code => 'PHY', :description => 'Physiotherapist', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      ProgrammeElement.populate(42, [ 
                    { :position => 0, :column_name => 'cont_contact_type'},
                    { :position => 1, :column_name => 'conl_contact_location'}])
          
    end    
  end

  def self.down
  end
end
