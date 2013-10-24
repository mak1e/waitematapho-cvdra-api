class AddClaimsData < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :exahos_exacarbation_hospital_admit, :string, :limit => 18
    add_column :claims_data, :exaevi_exacarbation_emergency_visit, :string, :limit => 18
    add_column :claims_data, :exaost_exacarbation_oral_steriod, :string, :limit => 18
    add_column :claims_data, :inhtec_inhaler_technique, :string, :limit => 18
    add_column :claims_data, :medcon_medical_concordance, :string, :limit => 18
    add_column :claims_data, :symnig_symptoms_night, :string, :limit => 18
    add_column :claims_data, :symday_symptoms_day, :string, :limit => 18
    add_column :claims_data, :actlim_activity_limitations, :string, :limit => 18
    add_column :claims_data, :actplan_action_plan, :string, :limit => 18
    add_column :claims_data, :asba_short_acting_bronchodiator, :string, :limit => 36
    add_column :claims_data, :asbause_short_acting_ba_usage, :string, :limit => 18
    add_column :claims_data, :ics_inhaled_corticosteroid, :string, :limit => 36
    add_column :claims_data, :laba_long_acting_bronchodiator, :string, :limit => 36
    add_column :claims_data, :pfmeter_peak_flow_meter, :string, :limit => 18
    add_column :claims_data, :a3lm_asthma_3rd_line_medication, :string, :limit => 36
    add_column :claims_data, :pefr_peak_expiratory_flow_rate, :integer
    add_column :claims_data, :pefrpb_pefr_post_bronchodiator, :integer
    add_column :claims_data, :pefrrev_pefr_reversibility, :integer
    add_column :claims_data, :pefrhig_pefr_highest, :integer
    add_column :claims_data, :pefrlow_pefr_lowest, :integer
    add_column :claims_data, :pefrvar_pefr_variability, :integer
    add_column :claims_data, :pefrpred_pefr_predicted, :integer
    add_column :claims_data, :pefrppred_pefr_percentage_predicted, :integer
    add_column :claims_data, :fev1_forced_expiratory_volume, :decimal, :precision => 8, :scale => 2
    add_column :claims_data, :fev1pred_fev1_predicted, :decimal, :precision => 8, :scale => 2
    add_column :claims_data, :fev1ppred_fev1_percentage_predicted, :integer
    add_column :claims_data, :fev1pb_fev1_post_bronchodiator, :decimal, :precision => 8, :scale => 2
    add_column :claims_data, :fev1pbi_fev1_post_bronch_improve, :decimal, :precision => 8, :scale => 2
    add_column :claims_data, :fev1pbip_fev1_post_bronch_improve_per, :integer
    add_column :claims_data, :fvc_forced_expiratory_vital_capacity, :decimal, :precision => 8, :scale => 2
    add_column :claims_data, :fev1fvc_fev1_fvc_ratio, :integer      
  end

  def self.down
    remove_column :claims_data, :exahos_exacarbation_hospital_admit
    remove_column :claims_data, :exaevi_exacarbation_emergency_visit
    remove_column :claims_data, :exaost_exacarbation_oral_steriod
    remove_column :claims_data, :inhtec_inhaler_technique
    remove_column :claims_data, :medcon_medical_concordance
    remove_column :claims_data, :symnig_symptoms_night
    remove_column :claims_data, :symday_symptoms_day
    remove_column :claims_data, :actlim_activity_limitations
    remove_column :claims_data, :actplan_action_plan
    remove_column :claims_data, :asba_short_acting_bronchodiator
    remove_column :claims_data, :asbause_short_acting_ba_usage
    remove_column :claims_data, :ics_inhaled_corticosteroid
    remove_column :claims_data, :laba_long_acting_bronchodiator
    remove_column :claims_data, :pefr_peak_expiratory_flow_rate
    remove_column :claims_data, :pefrpb_pefr_post_bronchodiator
    remove_column :claims_data, :pefrrev_pefr_reversibility
    remove_column :claims_data, :pefrhig_pefr_highest
    remove_column :claims_data, :pefrlow_pefr_lowest
    remove_column :claims_data, :pefrvar_pefr_variability
    remove_column :claims_data, :pefrpred_pefr_predicted
    remove_column :claims_data, :pefrppred_pefr_percentage_predicted
    remove_column :claims_data, :fev1_forced_expiratory_volume
    remove_column :claims_data, :fev1pred_fev1_predicted
    remove_column :claims_data, :fev1ppred_fev1_percentage_predicted
    remove_column :claims_data, :fev1pb_fev1_post_bronchodiator
    remove_column :claims_data, :fev1pbi_fev1_post_bronch_improve
    remove_column :claims_data, :fev1pbip_fev1_post_bronch_improve_per
    remove_column :claims_data, :fvc_forced_expiratory_vital_capacity
    remove_column :claims_data, :fev1fvc_fev1_fvc_ratio
  end
end
