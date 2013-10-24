class AddHhDsme < ActiveRecord::Migration
  def self.up
    add_column :programmes, 'internal_only', :boolean, :null => false, :default => false
    Programme.reset_column_information
    Programme.update_all( 'internal_only = 0')
    
    # add_column :claims_data, hba1c_hba1c
    # add_column :claims_data, ldl_ldl_cholesterol
    # add_column :claims_data, sbp_systolic_blood_pressure
    # add_column :claims_data, dbp_diastolic_blood_pressure
    # add_column :claims_data, bmi_body_mass_index
    
    add_column :claims_data, :diabscm_diabetes_self_care_measure, :integer
    add_column :claims_data, :supatt_support_person_attending, :integer
    add_column :claims_data, :ndxdiab_newly_dx_diabetes, :integer
    
    ClaimsData.reset_column_information
    DataField.populate_table
    DataField.update_all("data_type = 'boolean'","( column_name = 'supatt_support_person_attending' or column_name = 'ndxdiab_newly_dx_diabetes' )")
    
  end

  def self.down
    remove_column :claims_data, :diabscm_diabetes_self_care_measure
    remove_column :claims_data, :supatt_support_person_attending
    remove_column :claims_data, :ndxdiab_newly_dx_diabetes

    ClaimsData.reset_column_information
    DataField.populate_table    
    
    Programme.delete_all( 'id = 21' )
    FeeSchedule.delete_all( 'programme_id = 21' )
    ProgrammeElement.delete_all( 'programme_id = 21' )
    
  end
end
