class AddWhangCplus < ActiveRecord::Migration
  # Add Whanganiu PHO Care Plus Fields
  def self.up
    add_column :claims_data, :cpet_care_plus_enrolment_type, :string, :limit => 18
    add_column :claims_data, :vhsr_visit_health_status_reviewed, :boolean
    add_column :claims_data, :vcpr_visit_care_plan_reviewed,  :boolean
    add_column :claims_data, :vcpr_visit_crisis_plan_reviewed,  :boolean
    add_column :claims_data, :vped_visit_patient_education,  :boolean
    add_column :claims_data, :vrxr_visit_medication_review,  :boolean
    add_column :claims_data, :vpgr_visit_patient_goals_reviewed,  :boolean
    add_column :claims_data, :cpdr_care_plus_disenrolment_reason, :string, :limit => 28
    ClaimsData.reset_column_information
    DataField.populate_table    
    
    choices = [
        ['cpet_care_plus_enrolment_type', "New Enrolment\r\nTransfer"],
        ['cpdr_care_plus_disenrolment_reason', "Transferred\r\nDeceased\r\nPatient Choice\r\nNo Longer Eligible\r\nPractitioner Choice\r\nEnrolled in Error"]
        ]
        
     choices.each do |choice|
        df=DataField.find_by_column_name(choice[0]);
        raise ArgumentError, "Data field not found '#{choice[0]}'"  if !df
        df.choices = choice[1];
        df.save!
     end    
    
    
    Programme.create_with_id 11, :code => 'CPW', :description => 'Care Plus Whanganui'
    
    FeeSchedule.create_with_id 1100, :programme_id => 11, :code => 'CPE', :description => 'Care Plus Enrolment', :fee => 100.00, :gl_account_no => '11-0000'
    FeeSchedule.create_with_id 1101, :programme_id => 11, :code => 'CPR', :description => 'Care Plus Review', :fee => 22.00, :gl_account_no => '11-0001'
    FeeSchedule.create_with_id 1102, :programme_id => 11, :code => 'CPD', :description => 'Care Plus Dis-Enrolment', :fee => 28.00, :gl_account_no => '11-0002'
    
    ProgrammeElement.populate(11, [ 
                  { :position => 0,  :column_name => 'cpet_care_plus_enrolment_type'},
                  { :position => 4,  :column_name => 'vhsr_visit_health_status_reviewed'},
                  { :position => 5,  :column_name => 'vcpr_visit_care_plan_reviewed'},
                  { :position => 6,  :column_name => 'vcpr_visit_crisis_plan_reviewed'},
                  { :position => 8,  :column_name => 'vped_visit_patient_education'},
                  { :position => 9,  :column_name => 'vrxr_visit_medication_review'},
                  { :position => 10, :column_name => 'vpgr_visit_patient_goals_reviewed'},
                  { :position => 12, :column_name => 'cpdr_care_plus_disenrolment_reason'}])
  end

  def self.down
    remove_column :claims_data, :cpet_care_plus_enrolment_type
    remove_column :claims_data, :vhsr_visit_health_status_reviewed
    remove_column :claims_data, :vcpr_visit_care_plan_reviewed
    remove_column :claims_data, :vcpr_visit_crisis_plan_reviewed
    remove_column :claims_data, :vped_visit_patient_education
    remove_column :claims_data, :vrxr_visit_medication_review
    remove_column :claims_data, :vpgr_visit_patient_goals_reviewed
    remove_column :claims_data, :cpdr_care_plus_disenrolment_reason
    ClaimsData.reset_column_information
    DataField.populate_table    

    Programme.delete_all( 'id = 11')
    FeeSchedule.delete_all( 'programme_id = 11')
    ProgrammeElement.delete_all( 'programme_id = 11')    
    
  end
end
