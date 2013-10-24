class AddAlcoholScreening < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /phocm/ )
      # Delete programme 25, in development/test system
      Programme.delete_all('id=25');
      FeeSchedule.delete_all('programme_id=25');
    end
    
    if ( Settings.database =~ /hhcm|phocm/ )
      puts "Alcohol Screening Pilot (ex Whanganui) - Waitemata/Harbour PHO"

      Programme.create_with_id 25, :code => 'PDAC', :description => 'Alcohol Screening and Assess'
      
      FeeSchedule.create_with_id 2500, :programme_id => 25, :code => 'AA', :description => 'Alcohol Brief Assessment', :fee => 15.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          

      FeeSchedule.create_with_id 2501, :programme_id => 25, :code => 'AAD', :description => 'Alcohol Detailed Clinical Assessment', :fee => 45.00, :gl_account_no => '0000-00',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1, 
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          

      FeeSchedule.create_with_id 2502, :programme_id => 25, :code => 'AAF', :description => 'Alcohol Assessment Follow-up', :fee => 0.00, :gl_account_no => '0000-00',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
    end
    if ( Programme.exists?(25) )
      ProgrammeElement.populate(25, [ 
                    { :position => 0,  :column_name => 'alus_alcohol_under_surveillance'},
                    { :position => 1,  :column_name => 'alfq_alcohol_frequency'},
                    { :position => 2,  :column_name => 'alds_alcohol_drinks_per_session'},
                    { :position => 3,  :column_name => 'albf_alcohol_binge_frequency'},
                    
                    { :position => 4,  :column_name => 'dcsa_drink_check_section_a'},
                    { :position => 5,  :column_name => 'dcsb_drink_check_section_b'},
                    { :position => 6,  :column_name => 'dcsc_drink_check_section_c'},
                    { :position => 7,  :column_name => 'abass_abuse_assessment'},

                    { :position => 8,  :column_name => 'refto_Referral_To'},
                    
                    { :position => 12,  :column_name => 'alrc_alcohol_readiness_to_change'},
                    { :position => 13,  :column_name => 'alag_alcohol_advice_given'},
                    { :position => 14,  :column_name => 'preg_pregnant'}]);
    end
    if ( Programme.exists?(8) )
      # Add new Mental Heath, Transfered to Other
      puts "Add M Health, Transferred"
      FeeSchedule.create_with_id 821, :programme_id => 8, :code => 'PMTX', :description => 'Transferred to other Service', :fee => 0.00, :gl_account_no => '',
        :is_a_exit_service => 1, :is_a_entry_service => 0, :is_a_practice_service => 1, :is_a_declined_service => 1 
    end
    
  end

  def self.down
  end
end
