class B4scClaimData  < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :chqin_child_heath_q_interpretation  , :string, :limit => 18
    add_column :claims_data, :chqre_child_heath_q_referral  , :string, :limit => 18
    add_column :claims_data, :chqres_child_heath_q_referral_status  , :string, :limit => 18
    add_column :claims_data, :imm4ud_4y_immunisation_up_to_date , :string, :limit => 18
    add_column :claims_data, :immvt_immunisation_vacc_today , :string, :limit => 18
    add_column :claims_data, :immre_immunisation_referral , :string, :limit => 18
    add_column :claims_data, :immres_immunisation_referral_status , :string, :limit => 18
    add_column :claims_data, :growin_growth_measure_interpretation  , :string, :limit => 18
    add_column :claims_data, :growre_growth_measure_referral  , :string, :limit => 18
    add_column :claims_data, :growres_growth_measure_referral_status  , :string, :limit => 18
    add_column :claims_data, :dentde_dental_decay , :string, :limit => 18
    add_column :claims_data, :denten_dental_enrolled  , :string, :limit => 18
    add_column :claims_data, :dentent_dental_enrolled_today , :string, :limit => 18
    add_column :claims_data, :dentin_dental_interpretation  , :string, :limit => 18
    add_column :claims_data, :dentre_dental_referral  , :string, :limit => 18
    add_column :claims_data, :dentres_dental_referral_status  , :string, :limit => 18
    add_column :claims_data, :vishs_vision_hearing_status , :string, :limit => 18
    add_column :claims_data, :vishr_vision_hearing_referral , :string, :limit => 18
    add_column :claims_data, :vishrs_vision_hearing_referral_status , :string, :limit => 18
    add_column :claims_data, :pedsss_peds_significant_score , :integer
    add_column :claims_data, :pedsns_peds_non_significant_score , :integer
    add_column :claims_data, :pedsin_peds_interpretation  , :string, :limit => 18
    add_column :claims_data, :pedsref_peds_referral , :string, :limit => 18
    add_column :claims_data, :pedsrefs_peds_referral_status , :string, :limit => 18
    add_column :claims_data, :sdqess_sdq_emotional_symptoms_score , :integer
    add_column :claims_data, :sdqcps_sdq_conduct_problems_score , :integer
    add_column :claims_data, :sdqhys_sdq_hyperactivity_score  , :integer
    add_column :claims_data, :sdqpps_sdq_peer_problems_score  , :integer
    add_column :claims_data, :sdqtds_sdq_total_difficulties_score , :integer
    add_column :claims_data, :sdqpbs_sdq_prosocial_behaviour_score  , :integer
    add_column :claims_data, :sdqin_sdq_interpretation  , :string, :limit => 18
    add_column :claims_data, :sdqref_sdq_referral , :string, :limit => 18
    add_column :claims_data, :sdqrefs_sdq_referral_status , :string, :limit => 18    
    add_column :claims_data, :pedsref2_peds_referral_2 , :string, :limit => 18    
    add_column :claims_data, :pedsref2s_peds_referral_2_status , :string, :limit => 18    
    add_column :claims_data, :sdqref2_sdq_referral_2 , :string, :limit => 18    
    add_column :claims_data, :sdqref2s_sdq_referral_2_status , :string, :limit => 18   
    add_column :claims_data, :nokrel_nok_relationship , :string, :limit => 18   
    add_column :claims_data, :nokgn_nok_given_names , :string, :limit => 18   
    add_column :claims_data, :nokfn_nok_family_name , :string, :limit => 18   
  end

  def self.down

  end
end
