class AddHbphoPnap < ActiveRecord::Migration
  def self.up
    # add_column :claims_data, :nosess_number_of_sessions, :integer # Already present
    add_column :claims_data, :noga_number_of_group_attendances, :integer
    add_column :claims_data, :nopga_number_of_partner_group_attendances, :integer
    add_column :claims_data, :pnrt_pnap_referral_to, :string, :limit => 48
    add_column :claims_data, :pnrt2_pnap_referral_to_2, :string, :limit => 48
    add_column :claims_data, :epdssc_epds_score, :integer
    add_column :claims_data, :epds10_epds_self_harm, :integer
    
    ClaimsData.reset_column_information
    DataField.populate_table
    choices = [
        ['pnrt_pnap_referral_to', 
           "DHB Community Mental Health Team\r\nDHB Drug and Alcohol services\r\nDHB Crisis Assessment and Treatment Team\r\nParenting course\r\nOther family services at Napier Family Centre\r\nSupport Services\r\nOther"],
        ['pnrt2_pnap_referral_to_2', 
           "DHB Community Mental Health Team\r\nDHB Drug and Alcohol services\r\nDHB Crisis Assessment and Treatment Team\r\nParenting course\r\nOther family services at Napier Family Centre\r\nSupport Services\r\nOther"]]
    choices.each do |choice|
        df=DataField.find_by_column_name(choice[0]);
        raise ArgumentError, "Data field not found '#{choice[0]}'"  if !df
        df.choices = choice[1];
        df.save!
    end

    if ( Settings.database =~ /hbpho|phocm/ )
      puts "HBPHO - Post-natal Adjustment Programme"
      
      Programme.create_with_id 26, :code => 'PNAP', :description => 'Post-natal Adjustment Programme'
      
      FeeSchedule.create_with_id 2600, :programme_id => 26, :code => 'REF', :description => 'Referral PNAP', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          

      FeeSchedule.create_with_id 2601, :programme_id => 26, :code => 'RNR', :description => 'Referral not required', :fee => 0.00, :gl_account_no => '0000-00',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1, 
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          

      FeeSchedule.create_with_id 2602, :programme_id => 26, :code => 'EOC', :description => 'End of Care Report', :fee => 0.00, :gl_account_no => '0000-00',
          :is_a_entry_service => 0, :is_a_exit_service => 1, :is_a_practice_service => 0,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

          
      ProgrammeElement.populate(26, [ 
                    { :position => 0,  :column_name => 'nosess_number_of_sessions'},
                    
                    { :position => 4,  :column_name => 'noga_number_of_group_attendances'},
                    { :position => 5,  :column_name => 'nopga_number_of_partner_group_attendances'},
                    
                    { :position => 8,  :column_name => 'pnrt_pnap_referral_to'},
                    
                    { :position => 12,  :column_name => 'pnrt2_pnap_referral_to_2'},
                    
                    { :position => 16,  :column_name => 'epdssc_epds_score'},
                    { :position => 17,  :column_name => 'epds10_epds_self_harm'} ]);
    end
  end

  def self.down
    remove_column :claims_data, :noga_number_of_group_attendances
    remove_column :claims_data, :nopga_number_of_partner_group_attendances
    remove_column :claims_data, :pnrt_pnap_referral_to
    remove_column :claims_data, :pnrt2_pnap_referral_to_2
    remove_column :claims_data, :epdssc_epds_score
    remove_column :claims_data, :epds10_epds_self_harm
    
    Programme.delete_all( 'id = 26' )
    FeeSchedule.delete_all( 'programme_id = 26' )
    
  end
end
