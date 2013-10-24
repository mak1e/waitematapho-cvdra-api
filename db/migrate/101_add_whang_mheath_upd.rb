class AddWhangMheathUpd < ActiveRecord::Migration
  def self.up
    puts "Adding Additional Mental Health Fields (wrpho)"
    add_column :claims_data, :hovi_home_visit, :string, :limit => 8
    add_column :claims_data, :rtow_return_to_work, :string, :limit => 18
    add_column :claims_data, :prov_providers_name, :string, :limit => 18
    
    ClaimsData.reset_column_information
    DataField.populate_table    
    
    if ( Programme.exists?(12) )
      ProgrammeElement.populate(12, [ 
                  { :position => 0,  :column_name => 'prov_providers_name'},
                  { :position => 1,  :column_name => 'mhaod_mhealth_contract_alcohol_other_drug'},
                  { :position => 2,  :column_name => 'mhmoh_mhealth_contract_ministry_of_health'},
                  { :position => 3,  :column_name => 'mhmsd_mhealth_contract_ministry_of_social_dev'},
                  
                  { :position => 4,  :column_name => 'mhapt_mhealth_appointment_type'},
                  { :position => 5,  :column_name => 'refft_referral_from_type'},
                  { :position => 6,  :column_name => 'reffn_referral_from_name'},
                  { :position => 7,  :column_name => 'refda_date_of_referral'},
                  
                  { :position => 8,  :column_name => 'mhatt_mhealth_attendance_type'},
                  { :position => 9,  :column_name => 'hovi_home_visit'},
                  { :position => 10,  :column_name => 'mhost_mhealth_one_off_session_type'},
                  
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
                  
                  { :position => 32,  :column_name => 'rtow_return_to_work'},
                  { :position => 33,  :column_name => 'mhex_mhealth_exit_reason'}])
      
    end
    
    
  end

  def self.down
    remove_column :claims_data, :hovi_home_visit
    remove_column :claims_data, :rtow_return_to_work
    remove_column :claims_data, :prov_providers_name
  end
end
