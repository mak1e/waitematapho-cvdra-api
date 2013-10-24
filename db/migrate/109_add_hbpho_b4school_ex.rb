class AddHbphoB4schoolEx < ActiveRecord::Migration
  def self.up
    puts "Adding SDQ-T Teacher Sent/Completed (hbpho)"
    add_column :claims_data, :sdqtc_sdq_t_completed, :string, :limit => 18
    puts "Adding Nok details "
    add_column :claims_data, :nokst_nok_street, :string, :limit => 30
    add_column :claims_data, :noksu_nok_suburb, :string, :limit => 20
    add_column :claims_data, :noksu_nok_city, :string, :limit => 20
    add_column :claims_data, :nokph_nok_phone, :string, :limit => 14
    add_column :claims_data, :nokce_nok_cell_phone, :string, :limit => 14

    ClaimsData.reset_column_information
    DataField.populate_table
    
    df=DataField.find_by_column_name('sdqtc_sdq_t_completed');
    df.label = 'SDQ-Teacher Sent';
    df.choices = "Yes\r\nN/a - No ECE\r\nDeclined";
    df.save!
    
    if (( Settings.database =~ /hbpho|phocm/ ) && ( Programme.exists?(6) ))
      
      ProgrammeElement.populate( 6,
                  [
                  { :position => 0, :column_name => 'nokgn_nok_given_names'},
                  { :position => 1, :column_name => 'nokfn_nok_family_name'},
                  { :position => 2, :column_name => 'nokrel_nok_relationship'},
                  { :position => 4, :column_name => 'nokst_nok_street'},
                  { :position => 5, :column_name => 'noksu_nok_suburb'},
                  { :position => 6, :column_name => 'noksu_nok_city'},
                  { :position => 8, :column_name => 'nokph_nok_phone'},
                  { :position => 9, :column_name => 'nokce_nok_cell_phone'},
                  { :position => 12, :column_name => 'chqin_child_heath_q_interpretation'},
                  { :position => 16, :column_name => 'heig_height'},
                  { :position => 17, :column_name => 'weig_weight'},
                  { :position => 20, :column_name => 'bmi_body_mass_index'},
                  { :position => 21, :column_name => 'growin_growth_measure_interpretation'},
                  { :position => 24, :column_name => 'denten_dental_enrolled'},
                  { :position => 25, :column_name => 'dentent_dental_enrolled_today'},
                  { :position => 28, :column_name => 'dentde_dental_decay'},
                  { :position => 29, :column_name => 'dentin_dental_interpretation'},
                  { :position => 32, :column_name => 'vishs_vision_hearing_status'},
                  { :position => 36, :column_name => 'pedsss_peds_significant_score'},
                  { :position => 40, :column_name => 'pedsns_peds_non_significant_score'},
                  { :position => 41, :column_name => 'pedsin_peds_interpretation'},
                  { :position => 48, :column_name => 'sdqess_sdq_emotional_symptoms_score'},
                  { :position => 49, :column_name => 'sdqcps_sdq_conduct_problems_score'},
                  { :position => 50, :column_name => 'sdqhys_sdq_hyperactivity_score'},
                  { :position => 52, :column_name => 'sdqpps_sdq_peer_problems_score'},
                  { :position => 54, :column_name => 'sdqpbs_sdq_prosocial_behaviour_score'},
                  { :position => 56, :column_name => 'sdqtds_sdq_total_difficulties_score'},
                  { :position => 57, :column_name => 'sdqin_sdq_interpretation'},
                  { :position => 58, :column_name => 'sdqtc_sdq_t_completed'},
                  { :position => 64, :column_name => 'imm4ud_4y_immunisation_up_to_date'},
                  { :position => 65, :column_name => 'immvt_immunisation_vacc_today'},
                  { :position => 68, :column_name => 'chqre_child_heath_q_referral'},
                  { :position => 69, :column_name => 'chqres_child_heath_q_referral_status'},
                  { :position => 70, :column_name => 'chqred_child_heath_q_referral_date'},
                  { :position => 72, :column_name => 'growre_growth_measure_referral'},
                  { :position => 73, :column_name => 'growres_growth_measure_referral_status'},
                  { :position => 74, :column_name => 'growred_growth_measure_referral_date'},
                  { :position => 76, :column_name => 'dentre_dental_referral'},
                  { :position => 77, :column_name => 'dentres_dental_referral_status'},
                  { :position => 78, :column_name => 'dentred_dental_referral_date'},
                  { :position => 80, :column_name => 'vishr_vision_hearing_referral'},
                  { :position => 81, :column_name => 'vishrs_vision_hearing_referral_status'},
                  { :position => 82, :column_name => 'vishrd_vision_hearing_referral_date'},
                  { :position => 84, :column_name => 'pedsref_peds_referral'},
                  { :position => 85, :column_name => 'pedsrefs_peds_referral_status'},
                  { :position => 86, :column_name => 'pedsrefd_peds_referral_date'},
                  { :position => 88, :column_name => 'pedsref2_peds_referral_2'},
                  { :position => 89, :column_name => 'pedsref2s_peds_referral_2_status'},
                  { :position => 90, :column_name => 'pedsref2d_peds_referral_2_date'},
                  { :position => 92, :column_name => 'sdqref_sdq_referral'},
                  { :position => 93, :column_name => 'sdqrefs_sdq_referral_status'},
                  { :position => 94, :column_name => 'sdqrefd_sdq_referral_date'},
                  { :position => 96, :column_name => 'sdqref2_sdq_referral_2'},
                  { :position => 97, :column_name => 'sdqref2s_sdq_referral_2_status'},
                  { :position => 98, :column_name => 'sdqref2d_sdq_referral_2_date'},
                  { :position => 100, :column_name => 'immre_immunisation_referral'},
                  { :position => 101, :column_name => 'immres_immunisation_referral_status'},
                  { :position => 102, :column_name => 'immred_immunisation_referral_date'}  ])
   
    end
  end

  def self.down
    remove_column :claims_data, :sdqtc_sdq_t_completed
    remove_column :claims_data, :nokst_nok_street
    remove_column :claims_data, :noksu_nok_suburb
    remove_column :claims_data, :noksu_nok_city
    remove_column :claims_data, :nokph_nok_phone
    remove_column :claims_data, :nokce_nok_cell_phone
  end
end
