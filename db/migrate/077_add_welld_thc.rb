class AddWelldThc < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :hcra_hcheck_referring_agency, :string, :limit => 28
    # Clinical Areas Covered
    add_column :claims_data, :canex_nutrition_exercise, :boolean
    add_column :claims_data, :casmk_smoking, :boolean
    add_column :claims_data, :cacvdr_cvd_risk, :boolean
    add_column :claims_data, :cadiab_diabetes_management, :boolean
    add_column :claims_data, :cabre_breast_health, :boolean
    add_column :claims_data, :cacxs_cervical_screening, :boolean
    add_column :claims_data, :casxh_sexual_health, :boolean
    add_column :claims_data, :caalc_alcohol_consumption, :boolean
    add_column :claims_data, :caohn_other_heath_need, :boolean
    
    # Outcomes from This Check
    add_column :claims_data, :ocnoc_no_concerns, :boolean
    add_column :claims_data, :ocndm_new_diagnosis_made, :boolean
    add_column :claims_data, :ocino_investigations_ordered, :boolean
    add_column :claims_data, :ocecr_existing_conditions_reviewed, :boolean
    add_column :claims_data, :ocrfm_referrals_made, :boolean
    add_column :claims_data, :ocfur_follow_up_required, :boolean
    
    ClaimsData.reset_column_information
    DataField.populate_table    

    Programme.create_with_id 15, :code => 'THC', :description => 'Targeted Health Check'
    
    FeeSchedule.create_with_id 1500, :programme_id => 15, :code => 'THCI', :description => 'Initial', :fee => 80.00, :gl_account_no => '6409-74', :is_the_default => true
    FeeSchedule.create_with_id 1501, :programme_id => 15, :code => 'THCF', :description => 'Follow-up', :fee => 30.00, :gl_account_no => '6409-74'
    FeeSchedule.create_with_id 1502, :programme_id => 15, :code => 'THCVD', :description => 'Initial-CVD', :fee => 40.00, :gl_account_no => '6409-74'
    
    ProgrammeElement.populate(15, [ 
                  { :position => 0,  :column_name => 'hcra_hcheck_referring_agency'},
                  
                  { :position => 4,  :column_name => 'canex_nutrition_exercise'},
                  { :position => 5,  :column_name => 'casmk_smoking'},
                  { :position => 6,  :column_name => 'cacvdr_cvd_risk'},
                  { :position => 7,  :column_name => 'cadiab_diabetes_management'},
                  
                  { :position => 8,  :column_name => 'cabre_breast_health'},
                  { :position => 9,  :column_name => 'cacxs_cervical_screening'},
                  { :position => 10,  :column_name => 'casxh_sexual_health'},
                  { :position => 11,  :column_name => 'caalc_alcohol_consumption'},
                  
                  { :position => 12,  :column_name => 'ocnoc_no_concerns'},
                  { :position => 13,  :column_name => 'ocndm_new_diagnosis_made'},
                  { :position => 14,  :column_name => 'ocino_investigations_ordered'},
                  { :position => 15,  :column_name => 'ocecr_existing_conditions_reviewed'},
                  
                  { :position => 16,  :column_name => 'ocrfm_referrals_made'},
                  { :position => 17,  :column_name => 'ocfur_follow_up_required'} ])
    
  end


  def self.down
    remove_column :claims_data, :hcra_hcheck_referring_agency
    remove_column :claims_data, :canex_nutrition_exercise
    remove_column :claims_data, :casmk_smoking
    remove_column :claims_data, :cacvdr_cvd_risk
    remove_column :claims_data, :cadiab_diabetes_management
    remove_column :claims_data, :cabre_breast_health
    remove_column :claims_data, :cacxs_cervical_screening
    remove_column :claims_data, :casxh_sexual_health
    remove_column :claims_data, :caalc_alcohol_consumption
    remove_column :claims_data, :caohn_other_heath_need
    
    remove_column :claims_data, :ocnoc_no_concerns
    remove_column :claims_data, :ocndm_new_diagnosis_made
    remove_column :claims_data, :ocino_investigations_ordered
    remove_column :claims_data, :ocecr_existing_conditions_reviewed
    remove_column :claims_data, :ocrfm_referrals_made
    remove_column :claims_data, :ocfur_follow_up_required
        
    ClaimsData.reset_column_information
    DataField.populate_table    
    
    Programme.delete_all( 'id = 15')
    FeeSchedule.delete_all( 'programme_id = 15')    
    ProgrammeElement.delete_all( 'programme_id = 15')    
    
  end
end
