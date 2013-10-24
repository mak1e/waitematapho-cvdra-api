class AddWhangMhealth < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :mhaod_mhealth_contract_alcohol_other_drug, :boolean
    add_column :claims_data, :mhmoh_mhealth_contract_ministry_of_health, :boolean
    add_column :claims_data, :mhmsd_mhealth_contract_ministry_of_social_dev, :boolean
    add_column :claims_data, :mhapt_mhealth_appointment_type, :string, :limit => 18
    add_column :claims_data, :refft_referral_from_type, :string, :limit => 18
    add_column :claims_data, :reffn_referral_from_name, :string, :limit => 18
    add_column :claims_data, :refda_date_of_referral, :date
    add_column :claims_data, :mhatt_mhealth_attendance_type, :string, :limit => 18
    add_column :claims_data, :mhost_mhealth_one_off_session_type, :string, :limit => 18
    add_column :claims_data, :reftt_referral_to_type,:string, :limit => 28
    add_column :claims_data, :reftn_referral_to_name, :string, :limit => 18
    add_column :claims_data, :refto_referral_to_other, :string, :limit => 18
    add_column :claims_data, :mhsty_mhealth_session_type, :string, :limit => 18
    add_column :claims_data, :mhk10_mhealth_kessler_10, :string, :limit => 4
    add_column :claims_data, :mhkde_mhealth_kessler_10_declined, :boolean
    add_column :claims_data, :comor_co_morbidities_read, :string, :limit => 8
    add_column :claims_data, :comor2_co_morbidities_read_2, :string, :limit => 8
    add_column :claims_data, :btwc_barriers_to_work_code, :string, :limit => 4
    add_column :claims_data, :btwc2_barriers_to_work_code_2, :string, :limit => 4
    add_column :claims_data, :btwc3_barriers_to_work_code_3, :string, :limit => 4
    add_column :claims_data, :btwc4_barriers_to_work_code_4, :string, :limit => 4
    add_column :claims_data, :mhex_mhealth_exit_reason, :string, :limit => 28
    ClaimsData.reset_column_information
    DataField.populate_table    

    Programme.create_with_id 12, :code => 'PCMH', :description => 'Primary Care MH - WRPHO'
    
    FeeSchedule.create_with_id 1200, :programme_id => 12, :code => 'MHI', :description => 'PCMH Initial', :fee => 0.00, :gl_account_no => '12-0000'
    FeeSchedule.create_with_id 1201, :programme_id => 12, :code => 'MHF', :description => 'PCMH Follow-up', :fee => 0.00, :gl_account_no => '12-0001'
    
    
    choices = [
        ['mhaod_mhealth_contract_alcohol_other_drug', "Yes"],
        ['mhmoh_mhealth_contract_ministry_of_health', "Yes"],
        ['mhmsd_mhealth_contract_ministry_of_social_dev', "Yes"],
        ['mhkde_mhealth_kessler_10_declined', "Yes"],
        ['mhmsd_mhealth_contract_ministry_of_social_dev', "Yes"]]
    
     choices.each do |choice|
        df=DataField.find_by_column_name(choice[0]);
        raise ArgumentError, "Data field not found '#{choice[0]}'"  if !df
        df.choices = choice[1];
        df.save!
      end
      
    ProgrammeElement.populate(12, [ 
                  { :position => 0,  :column_name => 'mhaod_mhealth_contract_alcohol_other_drug'},
                  { :position => 1,  :column_name => 'mhmoh_mhealth_contract_ministry_of_health'},
                  { :position => 2,  :column_name => 'mhmsd_mhealth_contract_ministry_of_social_dev'},
                  
                  { :position => 4,  :column_name => 'mhapt_mhealth_appointment_type'},
                  { :position => 5,  :column_name => 'refft_referral_from_type'},
                  { :position => 6,  :column_name => 'reffn_referral_from_name'},
                  { :position => 7,  :column_name => 'refda_date_of_referral'},
                  
                  { :position => 8,  :column_name => 'mhatt_mhealth_attendance_type'},
                  { :position => 9,  :column_name => 'mhost_mhealth_one_off_session_type'},
                  
                  { :position => 12,  :column_name => 'mhdx_mhealth_diagnosis'},
                  { :position => 13,  :column_name => 'mhdx2_mhealth_diagnosis_2'},
                  { :position => 14,  :column_name => 'mhdx3_mhealth_diagnosis_3'},
                  
                  { :position => 16,  :column_name => 'reftt_referral_to_type'},
                  { :position => 17,  :column_name => 'reftn_referral_to_name'},
                  { :position => 18,  :column_name => 'refto_referral_to_other'},
                  
                  { :position => 20,  :column_name => 'mhsty_mhealth_session_type'},
                  { :position => 21,  :column_name => 'mhk10_mhealth_kessler_10'},
                  { :position => 22,  :column_name => 'mhkde_mhealth_kessler_10_declined'},
                  
                  { :position => 24,  :column_name => 'comor_co_morbidities_read'},
                  { :position => 25,  :column_name => 'comor2_co_morbidities_read_2'},
                  
                  { :position => 28,  :column_name => 'btwc_barriers_to_work_code'},
                  { :position => 29,  :column_name => 'btwc2_barriers_to_work_code_2'},
                  { :position => 30,  :column_name => 'btwc3_barriers_to_work_code_3'},
                  { :position => 31,  :column_name => 'btwc4_barriers_to_work_code_4'},
                  
                  { :position => 32,  :column_name => 'mhex_mhealth_exit_reason'}])

  end

  def self.down
    remove_column :claims_data, :mhaod_mhealth_contract_alcohol_other_drug
    remove_column :claims_data, :mhmoh_mhealth_contract_ministry_of_health
    remove_column :claims_data, :mhmsd_mhealth_contract_ministry_of_social_dev
    remove_column :claims_data, :mhapt_mhealth_appointment_type
    remove_column :claims_data, :refft_referral_from_type
    remove_column :claims_data, :reffn_referral_from_name
    remove_column :claims_data, :refda_date_of_referral
    remove_column :claims_data, :mhatt_mhealth_attendance_type
    remove_column :claims_data, :mhost_mhealth_one_off_session_type
    remove_column :claims_data, :reftt_referral_to_type
    remove_column :claims_data, :reftn_referral_to_name
    remove_column :claims_data, :refto_referral_to_other
    remove_column :claims_data, :mhsty_mhealth_session_type
    remove_column :claims_data, :mhk10_mhealth_kessler_10
    remove_column :claims_data, :mhkde_mhealth_kessler_10_declined
    remove_column :claims_data, :comor_co_morbidities_read
    remove_column :claims_data, :comor2_co_morbidities_read_2
    remove_column :claims_data, :btwc_barriers_to_work_code
    remove_column :claims_data, :btwc2_barriers_to_work_code_2
    remove_column :claims_data, :btwc3_barriers_to_work_code_3
    remove_column :claims_data, :btwc4_barriers_to_work_code_4
    remove_column :claims_data, :mhex_mhealth_exit_reason
    ClaimsData.reset_column_information
    DataField.populate_table    

    Programme.delete_all( 'id = 12')
    FeeSchedule.delete_all( 'programme_id = 12') 
    ProgrammeElement.delete_all( 'programme_id = 12')    

  end
end
