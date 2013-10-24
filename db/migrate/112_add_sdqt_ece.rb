class AddSdqtEce < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :sdqtcec_sqd_t_ece, :string, :limit => 28  
    ClaimsData.reset_column_information
    DataField.populate_table
    
    if (( Settings.database =~ /hbpho|phocm/ ) && ( Programme.exists?(6) ))
      ProgrammeElement.populate( 6,
                  [
                  { :position =>  0*4+0, :column_name => 'nokgn_nok_given_names'},
                  { :position =>  0*4+1, :column_name => 'nokfn_nok_family_name'},
                  { :position =>  0*4+2, :column_name => 'nokrel_nok_relationship'},
                  { :position =>  1*4+0, :column_name => 'nokst_nok_street'},
                  { :position =>  1*4+1, :column_name => 'noksu_nok_suburb'},
                  { :position =>  1*4+2, :column_name => 'noksu_nok_city'},
                  { :position =>  2*4+0, :column_name => 'nokph_nok_phone'},
                  { :position =>  2*4+1, :column_name => 'nokce_nok_cell_phone'},
                  { :position =>  3*4+0, :column_name => 'chqin_child_heath_q_interpretation'},
                  { :position =>  4*4+0, :column_name => 'heig_height'},
                  { :position =>  4*4+1, :column_name => 'weig_weight'},
                  { :position =>  5*4+0, :column_name => 'bmi_body_mass_index'},
                  { :position =>  5*4+1, :column_name => 'growin_growth_measure_interpretation'},
                  { :position =>  6*4+0, :column_name => 'denten_dental_enrolled'},
                  { :position =>  6*4+1, :column_name => 'dentent_dental_enrolled_today'},
                  { :position =>  7*4+0, :column_name => 'dentde_dental_decay'},
                  { :position =>  7*4+1, :column_name => 'dentin_dental_interpretation'},
                  { :position =>  8*4+0, :column_name => 'vishs_vision_hearing_status'},
                  { :position =>  9*4+0, :column_name => 'pedsss_peds_significant_score'},
                  { :position => 10*4+0, :column_name => 'pedsns_peds_non_significant_score'},
                  { :position => 10*4+1, :column_name => 'pedsin_peds_interpretation'},
                  { :position => 11*4+0, :column_name => 'sdqess_sdq_emotional_symptoms_score'},
                  { :position => 11*4+1, :column_name => 'sdqcps_sdq_conduct_problems_score'},
                  { :position => 11*4+2, :column_name => 'sdqhys_sdq_hyperactivity_score'},
                  { :position => 12*4+0, :column_name => 'sdqpps_sdq_peer_problems_score'},
                  { :position => 12*4+2, :column_name => 'sdqpbs_sdq_prosocial_behaviour_score'},
                  { :position => 13*4+0, :column_name => 'sdqtds_sdq_total_difficulties_score'},
                  { :position => 13*4+1, :column_name => 'sdqin_sdq_interpretation'},
                  
                  { :position => 14*4+0, :column_name => 'sdqtc_sdq_t_completed'},
                  { :position => 14*4+1, :column_name => 'sdqtcec_sqd_t_ece'},
                  
                  { :position => 15*4+0, :column_name => 'imm4ud_4y_immunisation_up_to_date'},
                  { :position => 15*4+1, :column_name => 'immvt_immunisation_vacc_today'},
                  { :position => 16*4+0, :column_name => 'chqre_child_heath_q_referral'},
                  { :position => 16*4+1, :column_name => 'chqres_child_heath_q_referral_status'},
                  { :position => 16*4+2, :column_name => 'chqred_child_heath_q_referral_date'},
                  { :position => 17*4+0, :column_name => 'growre_growth_measure_referral'},
                  { :position => 17*4+1, :column_name => 'growres_growth_measure_referral_status'},
                  { :position => 17*4+2, :column_name => 'growred_growth_measure_referral_date'},
                  { :position => 18*4+0, :column_name => 'dentre_dental_referral'},
                  { :position => 18*4+1, :column_name => 'dentres_dental_referral_status'},
                  { :position => 18*4+2, :column_name => 'dentred_dental_referral_date'},
                  { :position => 19*4+0, :column_name => 'vishr_vision_hearing_referral'},
                  { :position => 19*4+1, :column_name => 'vishrs_vision_hearing_referral_status'},
                  { :position => 19*4+2, :column_name => 'vishrd_vision_hearing_referral_date'},
                  { :position => 20*4+0, :column_name => 'pedsref_peds_referral'},
                  { :position => 20*4+1, :column_name => 'pedsrefs_peds_referral_status'},
                  { :position => 20*4+2, :column_name => 'pedsrefd_peds_referral_date'},
                  { :position => 21*4+0, :column_name => 'pedsref2_peds_referral_2'},
                  { :position => 21*4+1, :column_name => 'pedsref2s_peds_referral_2_status'},
                  { :position => 21*4+2, :column_name => 'pedsref2d_peds_referral_2_date'},
                  { :position => 22*4+0, :column_name => 'sdqref_sdq_referral'},
                  { :position => 22*4+1, :column_name => 'sdqrefs_sdq_referral_status'},
                  { :position => 22*4+2, :column_name => 'sdqrefd_sdq_referral_date'},
                  { :position => 23*4+0, :column_name => 'sdqref2_sdq_referral_2'},
                  { :position => 23*4+1, :column_name => 'sdqref2s_sdq_referral_2_status'},
                  { :position => 23*4+2, :column_name => 'sdqref2d_sdq_referral_2_date'},
                  { :position => 24*4+0, :column_name => 'immre_immunisation_referral'},
                  { :position => 24*4+1, :column_name => 'immres_immunisation_referral_status'},
                  { :position => 24*4+2, :column_name => 'immred_immunisation_referral_date'}  ])
      
    end
    
  end

  def self.down
    remove_column :claims_data, :sdqtcec_sqd_t_ece
  end
end
