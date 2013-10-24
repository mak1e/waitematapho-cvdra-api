class RedoDataFields < ActiveRecord::Migration
  def self.up

    change_column :claims_data, :pedsss_peds_significant_score , :integer
    change_column :claims_data, :pedsns_peds_non_significant_score , :integer
    change_column :claims_data, :sdqess_sdq_emotional_symptoms_score , :integer
    change_column :claims_data, :sdqcps_sdq_conduct_problems_score , :integer
    change_column :claims_data, :sdqhys_sdq_hyperactivity_score  , :integer
    change_column :claims_data, :sdqpps_sdq_peer_problems_score  , :integer
    change_column :claims_data, :sdqtds_sdq_total_difficulties_score , :integer
    change_column :claims_data, :sdqpbs_sdq_prosocial_behaviour_score  , :integer

    change_column :claims_data, :chqin_child_heath_q_interpretation  , :string, :limit => 28
    change_column :claims_data, :chqre_child_heath_q_referral  , :string, :limit => 28
    change_column :claims_data, :immre_immunisation_referral , :string, :limit => 28
    change_column :claims_data, :growin_growth_measure_interpretation  , :string, :limit => 28
    change_column :claims_data, :growre_growth_measure_referral  , :string, :limit => 28
    change_column :claims_data, :dentin_dental_interpretation  , :string, :limit => 28
    change_column :claims_data, :dentre_dental_referral  , :string, :limit => 28
    change_column :claims_data, :vishr_vision_hearing_referral , :string, :limit => 28
    change_column :claims_data, :pedsin_peds_interpretation  , :string, :limit => 28
    change_column :claims_data, :pedsref_peds_referral , :string, :limit => 28
    change_column :claims_data, :pedsref2_peds_referral_2 , :string, :limit => 28    
    change_column :claims_data, :sdqin_sdq_interpretation  , :string, :limit => 28
    change_column :claims_data, :sdqref_sdq_referral , :string, :limit => 28
    change_column :claims_data, :sdqref2_sdq_referral_2 , :string, :limit => 28    
    
    add_column :claims_data, :notes_notes, :string, :limit => 28    
    

    
    execute "delete from data_fields"

    DataField.populate_table
    
    require "db/migrate/040_add_data_fields_choices.rb"
    
    AddDataFieldsChoices.up
    
    require "db/migrate/045_add_b4sc_choices.rb"
    
    AddB4scChoices.up
    
  end

  def self.down
  end
end
