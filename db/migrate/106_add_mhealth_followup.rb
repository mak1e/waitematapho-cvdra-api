class AddMhealthFollowup < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :nosess_number_of_sessions, :integer
    ClaimsData.reset_column_information
    DataField.populate_table # Add new columns from claims_data 
    
    if ( Programme.exists?(8) )
      
        FeeSchedule.update_all("is_a_exit_service = 0,is_a_entry_service = 0","programme_id = 8")
        
        FeeSchedule.create_with_id 813, :programme_id => 8, :code => 'PMPHYT', :description => 'Psychotherapist', :fee => 0.00, :gl_account_no => '6-0000',
          :is_a_exit_service => 0, :is_a_entry_service => 0
        FeeSchedule.create_with_id 818, :programme_id => 8, :code => 'PMCOMP', :description => 'Complete', :fee => 0.00, :gl_account_no => '6-0000',
          :is_a_exit_service => 1, :is_a_entry_service => 0
        FeeSchedule.create_with_id 819, :programme_id => 8, :code => 'PMINCO', :description => 'In-Complete', :fee => 0.00, :gl_account_no => '6-0000',
          :is_a_exit_service => 1, :is_a_entry_service => 0, :is_a_declined_service => 1

        
        if ( FeeSchedule.exists?(800) ) # Initial GP
           f=FeeSchedule.find(800)
           
           f.is_a_entry_service = 1
           f.reminder_on = true
           f.reminder_in_weeks = 8
           f.reminder_note = 'No Outcome for referral'
           f.save!
        end

        if ( FeeSchedule.exists?(802) ) # Final Consult/Exit
           f=FeeSchedule.find(802);
           
           f.reminder_on = true
           f.reminder_in_weeks = 1
           f.reminder_note = 'Treatment complete missing'
           f.save!
        end

  
        ProgrammeElement.populate(8, [ 
                    { :position => 0, :column_name => 'mhdx_mhealth_diagnosis'},
                    { :position => 1, :column_name => 'mhdx2_mhealth_diagnosis_2'},
                    { :position => 2, :column_name => 'mhdx3_mhealth_diagnosis_3'},
                    
                    { :position => 4, :column_name => 'mhdx4_mhealth_diagnosis_4'},
                    { :position => 5, :column_name => 'mhdx5_mhealth_diagnosis_5'},
                    { :position => 6, :column_name => 'mhdx6_mhealth_diagnosis_6'},
                    
                    { :position => 8, :column_name => 'smok_smoking_history'},
                    { :position => 9, :column_name => 'como_co_morbidities'},
                    
                    { :position => 12, :column_name => 'mhk10_mhealth_kessler_10'},
                    { :position => 13, :column_name => 'mhphq9_mhealth_phq_9'},
                    { :position => 14, :column_name => 'qolr_quality_of_life_rating'},
                    
                    { :position => 16, :column_name => 'nosess_number_of_sessions'},
                    { :position => 17, :column_name => 'copa_co_payment_amount'}
                    ] )

    end

  end

  def self.down
  end
end
