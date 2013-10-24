class AstshmaClaimData < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :agea_age_of_asthma_diagnosis, :integer
    add_column :claims_data, :smpy_smoking_pack_years, :integer
    
    add_column :claims_data, :fvcpred_fvc_predicted, :decimal, :precision => 8, :scale => 2
    add_column :claims_data, :fvcppred_fvc_percentage_predicted, :integer
    
    rename_column :claims_data, :pefrrev_pefr_reversibility, :pefrpbip_pefr_post_bronch_improve_per
    rename_column :claims_data, :asba_short_acting_bronchodiator, :saba_short_acting_bronchodilator
    rename_column :claims_data, :asbause_short_acting_ba_usage, :sabause_short_acting_ba_usage
    rename_column :claims_data, :laba_long_acting_bronchodiator, :laba_long_acting_bronchodilator
    rename_column :claims_data, :pefrpb_pefr_post_bronchodiator, :pefrpb_pefr_post_bronchodilator
    rename_column :claims_data, :fvc_forced_expiratory_vital_capacity, :fvc_forced_vital_capacity
    rename_column :claims_data, :fev1fvc_fev1_fvc_ratio, :fev1fvcr_fev1_fvc_ratio
    
    remove_column :claims_data, :fev1pb_fev1_post_bronchodiator
    remove_column :claims_data, :fev1pbi_fev1_post_bronch_improve
    remove_column :claims_data, :fev1pbip_fev1_post_bronch_improve_per
  end

  def self.down
  end
end
