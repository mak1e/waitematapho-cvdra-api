class AddAsthmaTriggers < ActiveRecord::Migration
  def self.up
    puts "Adding Asthma History/Trigger Fields"
    add_column :claims_data, :hayf_hay_fever, :boolean
    add_column :claims_data, :hypv_hyperventilation, :boolean
    add_column :claims_data, :gord_gastro_oesophageal_reflux, :boolean
    add_column :claims_data, :rhin_rhinitis, :boolean
    add_column :claims_data, :ecze_eczema, :boolean
    add_column :claims_data, :infvac_influenza_vacc_given, :string, :limit => 8
    
    add_column :claims_data, :trgemo_trigger_emotions, :boolean
    add_column :claims_data, :trgani_trigger_animals, :boolean
    add_column :claims_data, :trgexe_trigger_exercise, :boolean
    add_column :claims_data, :trgfdr_trigger_food_drink, :boolean
    add_column :claims_data, :trgres_trigger_respiratory_infection, :boolean
    add_column :claims_data, :trgasp_trigger_aspirin, :boolean
    add_column :claims_data, :trgocc_trigger_occupational, :boolean
    add_column :claims_data, :trghor_trigger_hormonal, :boolean
    add_column :claims_data, :trgcai_trigger_cold_air, :boolean
    add_column :claims_data, :trgdus_trigger_dust, :boolean
    
    add_column :claims_data, :icsuse_ics_usage, :string, :limit => 8
    
    ClaimsData.reset_column_information
    DataField.populate_table
    
  end

  def self.down
    remove_column :claims_data, :smoc_smoking_outcome
  end
end
