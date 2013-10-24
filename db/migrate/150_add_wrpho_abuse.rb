class AddWrphoAbuse < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :refts_referral_to_status, :string, :limit => 18
    
    puts "Add Abuse, Family Violance Columns"
    # Family Violance
    add_column :claims_data, :abass_abuse_assessment, :string, :limit => 32
    add_column :claims_data, :abinc_abuse_screen_incomplete, :string, :limit => 32
    add_column :claims_data, :abmen_abuse_mental, :string, :limit => 28
    add_column :claims_data, :abphy_abuse_physical, :string, :limit => 28
    add_column :claims_data, :absex_abuse_sexual, :string, :limit => 28
    add_column :claims_data, :abneg_abuse_neglect, :string, :limit => 28
    add_column :claims_data, :acc_acc_accident, :string, :limit => 18
    add_column :claims_data, :advg_advice_info_given, :string, :limit => 28
    add_column :claims_data, :maosu_maori_support, :string, :limit => 28

    puts "Add Abuse, Additional Child Protection Columns"
    add_column :claims_data, :abvho_abuse_present_at_home, :string, :limit => 18
    add_column :claims_data, :abunc_abuse_uncorroborated_history, :string, :limit => 18
    add_column :claims_data, :abcyf_abuse_ho_cyfs_engagement, :string, :limit => 18
    add_column :claims_data, :abdel_abuse_delay_medical_advice, :string, :limit => 18
    add_column :claims_data, :abtra_abuse_history_trauma, :string, :limit => 18
    add_column :claims_data, :abvhi_abuse_changing_history, :string, :limit => 18
    add_column :claims_data, :abcdr_abuse_changing_dr, :string, :limit => 18
    add_column :claims_data, :abgus_abuse_gastrourinary_sx, :string, :limit => 18
    
    ClaimsData.reset_column_information
    DataField.populate_table
    
    if ( Settings.database =~ /wrpho|phocm/ )
      puts "Whanganui PHO - Child Protection"
      
      Programme.create_with_id 49, :code => 'CHPR', :description => 'Child Protection'

      FeeSchedule.create_with_id 4900, :programme_id => 49, :code => 'ASM', :description => 'Assessment', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      

      ProgrammeElement.populate(49, [ 
                   { :position => 0,  :column_name => 'abass_abuse_assessment'},
                   { :position => 1,  :column_name => 'acc_acc_accident'},
                   
                   { :position => 4,  :column_name => 'abmen_abuse_mental'},
                   { :position => 5,  :column_name => 'abphy_abuse_physical'},
                   { :position => 6,  :column_name => 'absex_abuse_sexual'},
                   { :position => 7,  :column_name => 'abneg_abuse_neglect'},
                   
                   { :position => 8,  :column_name => 'abvho_abuse_present_at_home'},
                   { :position => 9,  :column_name => 'abunc_abuse_uncorroborated_history'},
                   { :position => 10, :column_name => 'abcyf_abuse_ho_cyfs_engagement'},
                   { :position => 11, :column_name => 'abdel_abuse_delay_medical_advice'},
                   
                   { :position => 12, :column_name => 'abtra_abuse_history_trauma'},
                   { :position => 13, :column_name => 'abvhi_abuse_changing_history'},
                   { :position => 14, :column_name => 'abcdr_abuse_changing_dr'},
                   { :position => 15, :column_name => 'abgus_abuse_gastrourinary_sx'},
                   
                   { :position => 16, :column_name => 'reftt_referral_to_type'},
                   { :position => 17, :column_name => 'refto_referral_to_other'}
                 ]);      
      
      puts "Whanganui PHO -Family V Screening"
      
      Programme.create_with_id 50, :code => 'FVSC', :description => 'Family V Screening'
      

      FeeSchedule.create_with_id 5000, :programme_id => 50, :code => 'ASM', :description => 'Assessment', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0


                 
      ProgrammeElement.populate(50, [ 
                   { :position => 0,  :column_name => 'abass_abuse_assessment'},
                   { :position => 1,  :column_name => 'abinc_abuse_screen_incomplete'},
                   
                   { :position => 4,  :column_name => 'abmen_abuse_mental'},
                   { :position => 5,  :column_name => 'abphy_abuse_physical'},
                   { :position => 6,  :column_name => 'absex_abuse_sexual'},
                   { :position => 7,  :column_name => 'abneg_abuse_neglect'},
                   
                   { :position => 8,  :column_name => 'actplan_action_plan'},
                   { :position => 9,  :column_name => 'acc_acc_accident'},
                   { :position => 10, :column_name => 'preg_pregnant'},
                   
                   { :position => 12, :column_name => 'advg_advice_info_given'},
                   { :position => 13, :column_name => 'maosu_maori_support'},
                   
                   { :position => 16, :column_name => 'reftt_referral_to_type'},
                   { :position => 17, :column_name => 'refts_referral_to_status'}
                 ]);                 
      
    end       
  end

  def self.down
  end

    ClaimsData.reset_column_information
    DataField.populate_table
    
end
