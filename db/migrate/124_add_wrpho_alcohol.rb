class AddWrphoAlcohol < ActiveRecord::Migration
  def self.up
    
    add_column :claims_data, :alus_alcohol_under_surveillance, :string, :limit => 8
    add_column :claims_data, :alfq_alcohol_frequency, :string, :limit => 24
    add_column :claims_data, :alds_alcohol_drinks_per_session, :integer
    add_column :claims_data, :albf_alcohol_binge_frequency, :string, :limit => 18
    
    add_column :claims_data, :dcsa_drink_check_section_a, :integer
    add_column :claims_data, :dcsb_drink_check_section_b, :integer
    add_column :claims_data, :dcsc_drink_check_section_c, :integer
    
    change_column :claims_data, :refto_Referral_To, :string, :limit => 28
    
    add_column :claims_data, :alrc_alcohol_readiness_to_change, :string, :limit => 18
    add_column :claims_data, :alag_alcohol_advice_given, :string, :limit => 8

    ClaimsData.reset_column_information
    DataField.populate_table

    if ( Settings.database =~ /wrpho|phocm/ )
      puts "Alcohol Screening and Assess"

      # Diabetes Self Management Education for Harbour Health
      Programme.create_with_id 25, :code => 'PDAC', :description => 'Alcohol Screening and Assess'
      
      FeeSchedule.create_with_id 2500, :programme_id => 25, :code => 'AA', :description => 'Alcohol Brief Assessment', :fee => 20.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          

      FeeSchedule.create_with_id 2501, :programme_id => 25, :code => 'AAD', :description => 'Alcohol Detailed Clinical Assessment', :fee => 45.00, :gl_account_no => '0000-00',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1, 
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          

      FeeSchedule.create_with_id 2502, :programme_id => 25, :code => 'AAF', :description => 'Alcohol Assessment Follow-up', :fee => 30.00, :gl_account_no => '0000-00',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      ProgrammeElement.populate(25, [ 
                    { :position => 0,  :column_name => 'alus_alcohol_under_surveillance'},
                    { :position => 1,  :column_name => 'alfq_alcohol_frequency'},
                    { :position => 2,  :column_name => 'alds_alcohol_drinks_per_session'},
                    { :position => 3,  :column_name => 'albf_alcohol_binge_frequency'},
                    
                    { :position => 4,  :column_name => 'dcsa_drink_check_section_a'},
                    { :position => 5,  :column_name => 'dcsb_drink_check_section_b'},
                    { :position => 6,  :column_name => 'dcsc_drink_check_section_c'},

                    { :position => 8,  :column_name => 'refto_Referral_To'},
                    
                    { :position => 12,  :column_name => 'alrc_alcohol_readiness_to_change'},
                    { :position => 13,  :column_name => 'alag_alcohol_advice_given'} ]);
      
    end      
  end

  def self.down
    remove_column :claims_data, :alus_alcohol_under_surveillance
    remove_column :claims_data, :alfq_alcohol_frequency
    remove_column :claims_data, :alds_alcohol_drinks_per_session
    remove_column :claims_data, :albf_alcohol_binge_frequency
    
    remove_column :claims_data, :dcsa_drink_check_section_a
    remove_column :claims_data, :dcsb_drink_check_section_b
    remove_column :claims_data, :dcsc_drink_check_section_c
    
    
    remove_column :claims_data, :alrc_alcohol_readiness_to_change
    remove_column :claims_data, :alag_alcohol_advice_given
    
  end
end
