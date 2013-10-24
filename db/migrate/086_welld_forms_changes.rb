class WelldFormsChanges < ActiveRecord::Migration
  def self.up
    remove_column :claims_data, :ocnoc_no_concerns
    remove_column :claims_data, :ocndm_new_diagnosis_made
    remove_column :claims_data, :ocino_investigations_ordered
    remove_column :claims_data, :ocecr_existing_conditions_reviewed
    remove_column :claims_data, :ocrfm_referrals_made
    remove_column :claims_data, :ocfur_follow_up_required

    add_column :claims_data, :camedi_medications, :boolean
        
    ClaimsData.reset_column_information
    DataField.populate_table    

    if ( Programme.exists?(15) )
      ProgrammeElement.delete_all( 'programme_id = 15')        
      FeeSchedule.delete_all( 'id = 1502') 
      ProgrammeElement.populate(15, [ 
                  { :position => 0,  :column_name => 'hcra_hcheck_referring_agency'},
                  
                  { :position => 4,  :column_name => 'canex_nutrition_exercise'},
                  { :position => 5,  :column_name => 'casmk_smoking'},
                  { :position => 6,  :column_name => 'cacvdr_cvd_risk'},
                  { :position => 7,  :column_name => 'camedi_medications'},
                  
                  { :position => 8,  :column_name => 'cadiab_diabetes_management'},
                  { :position => 9,  :column_name => 'cabre_breast_health'},
                  { :position => 10,  :column_name => 'cacxs_cervical_screening'},
                  { :position => 11,  :column_name => 'casxh_sexual_health'},
                  
                  { :position => 12,  :column_name => 'caalc_alcohol_consumption'},
                  { :position => 13,  :column_name => 'caohn_other_heath_need'} ])
    end
    if ( Programme.exists?(16) )
      ProgrammeElement.delete_all( 'programme_id = 16')        
      ProgrammeElement.populate(16, [ 
                  { :position => 0,  :column_name => 'vhsr_visit_health_status_reviewed'},
                  { :position => 1,  :column_name => 'vcpr_visit_care_plan_reviewed'},
                  { :position => 2,  :column_name => 'vrxr_visit_medication_review'},
                  { :position => 3,  :column_name => 'vpgr_visit_patient_goals_reviewed'} ])    
    end
    
    if ( Programme.exists?(18) )
      FeeSchedule.delete_all( 'programme_id = 18') 
      FeeSchedule.create_with_id 1800, :programme_id => 18, :code => 'MHIA', :description => 'Initial Assessment', :fee => 36.00, :gl_account_no => '1800-00' 
      FeeSchedule.create_with_id 1801, :programme_id => 18, :code => 'MHHC', :description => 'Health Check', :fee => 50, :gl_account_no => '1800-00'
      FeeSchedule.create_with_id 1802, :programme_id => 18, :code => 'MHHO', :description => 'Handover', :fee => 36.00, :gl_account_no => '1800-00'
    end
  end

    if ( Programme.exists?(16) )
      ProgrammeElement.delete_all( 'programme_id = 16')        
      ProgrammeElement.populate(16, [ 
                  { :position => 0,  :column_name => 'vhsr_visit_health_status_reviewed'},
                  { :position => 1,  :column_name => 'vcpr_visit_care_plan_reviewed'},
                  { :position => 2,  :column_name => 'vrxr_visit_medication_review'},
                  { :position => 3,  :column_name => 'vpgr_visit_patient_goals_reviewed'} ])    
    end


  def self.down
    remove_column :claims_data, :camedi_medications
    
    add_column :claims_data, :ocnoc_no_concerns, :boolean
    add_column :claims_data, :ocndm_new_diagnosis_made, :boolean
    add_column :claims_data, :ocino_investigations_ordered, :boolean
    add_column :claims_data, :ocecr_existing_conditions_reviewed, :boolean
    add_column :claims_data, :ocrfm_referrals_made, :boolean
    add_column :claims_data, :ocfur_follow_up_required, :boolean
    
  end
end
