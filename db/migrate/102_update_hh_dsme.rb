class UpdateHhDsme < ActiveRecord::Migration
  def self.up
    puts "Adding follow up options to fee schedule"
    # NOTE: These fields are not used now, as change to be rules based !!!
    add_column :fee_schedules, :triggers_a_followup, :integer, :default => 0
    add_column :fee_schedules, :is_a_followup_service, :integer, :default => 0
    
    if ( Programme.exists?(21) )
      puts "Updating DSME Service options (hhealth)"
     
      FeeSchedule.delete_all( 'programme_id = 21' )
      ProgrammeElement.delete_all( 'programme_id = 21' )
      
      FeeSchedule.create_with_id 2100, :programme_id => 21, :code => 'DSREF', :description => 'Referral', :fee => 0.00, :gl_account_no => '0000-00', :is_the_default => true, :is_a_entry_service => 1, :is_a_exit_service  => 0
      FeeSchedule.create_with_id 2101, :programme_id => 21, :code => 'DSNOR', :description => 'Non Responder', :fee => 0.00, :gl_account_no => '0000-00', :is_a_entry_service => 0, :is_a_exit_service  => 1
      FeeSchedule.create_with_id 2102, :programme_id => 21, :code => 'DSDEC', :description => 'Declined', :fee => 0.00, :gl_account_no => '0000-00', :is_a_entry_service => 0, :is_a_exit_service  => 1

      FeeSchedule.create_with_id 2104, :programme_id => 21, :code => 'DSSESS', :description => 'Session', :fee => 0.00, :gl_account_no => '0000-00', :is_a_entry_service => 0, :is_a_exit_service  => 0
      FeeSchedule.create_with_id 2105, :programme_id => 21, :code => 'DSDIET', :description => 'Dieticial', :fee => 0.00, :gl_account_no => '0000-00', :is_a_entry_service => 0, :is_a_exit_service  => 0
      
      FeeSchedule.create_with_id 2107, :programme_id => 21, :code => 'DSINCO', :description => 'In Complete', :fee => 0.00, :gl_account_no => '0000-00', :is_a_entry_service => 0, :is_a_exit_service  => 1
      FeeSchedule.create_with_id 2108, :programme_id => 21, :code => 'DSCOMP', :description => 'Complete', :fee => 0.00, :gl_account_no => '0000-00', :is_a_entry_service => 0, :is_a_exit_service  => 1, :triggers_a_followup => 1
      
      FeeSchedule.create_with_id 2110, :programme_id => 21, :code => 'DSFUP', :description => 'Follow-up', :fee => 0.00, :gl_account_no => '0000-00', :is_a_entry_service => 0, :is_a_exit_service  => 0, :is_a_followup_service => 1
      FeeSchedule.create_with_id 2111, :programme_id => 21, :code => 'DSFDEC', :description => 'Follow-up Declined', :fee => 0.00, :gl_account_no => '0000-00', :is_a_entry_service => 0, :is_a_exit_service  => 0, :is_a_followup_service => 1

      ProgrammeElement.populate(21, [ 
                    { :position => 0,  :column_name => 'hba1c_hba1c'},
                    { :position => 1,  :column_name => 'ldl_ldl_cholesterol'},
                    
                    { :position => 4,  :column_name => 'sbp_systolic_blood_pressure'},
                    { :position => 5,  :column_name => 'dbp_diastolic_blood_pressure'},
                    { :position => 6,  :column_name => 'bmi_body_mass_index'},
                    
                    { :position => 8,  :column_name => 'diabscm_diabetes_self_care_measure'},
                    { :position => 9,  :column_name => 'ndxdiab_newly_dx_diabetes'},
                    { :position => 10,  :column_name => 'supatt_support_person_attending'}
                    ])
      
    end
  end

  def self.down
    remove_column :fee_schedules, :triggers_a_followup
    remove_column :fee_schedules, :is_a_followup_service
  end
end
