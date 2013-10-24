class AddHaurakiMobileNursing < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :ihd_heart_disease, :string, :limit => 18
    add_column :claims_data, :resp_respiratory_illnesses, :string, :limit => 18
    add_column :claims_data, :nurref_nutritionist_referral, :string, :limit => 18
    
    ClaimsData.reset_column_information
    DataField.populate_table

    
    if ( Settings.database =~ /haupho|phocm/ )
      puts "Hauraki PHO - Mobile Maori Nursing"
      
      Programme.create_with_id 52, :code => 'MMN', :description => 'Mobile Maori Nursing'

      FeeSchedule.create_with_id 5200, :programme_id => 52, :code => 'ENR', :description => 'Enrollment', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 5201, :programme_id => 52, :code => 'CON', :description => 'Follow-up', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
    
      FeeSchedule.create_with_id 5202, :programme_id => 52, :code => 'EXI', :description => 'Exit', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0


       ProgrammeElement.populate(52, [ 
                   { :position => 0,  :column_name => 'diab_type_of_diabetes' },
                   { :position => 1,  :column_name => 'ihd_heart_disease'},
                   { :position => 2,  :column_name => 'resp_respiratory_illnesses'},
                   
                   { :position => 4,  :column_name => 'refft_referral_from_type'},
                   
                   { :position => 8,  :column_name => 'reftt_referral_to_type'},
                   { :position => 9,  :column_name => 'nurref_nutritionist_referral',},
                   { :position => 10,  :column_name => 'podref_podiatary_referral',},
                   
                   { :position => 12,  :column_name => 'smref_smoking_action_referral',},
                   { :position => 13,  :column_name => 'refto_referral_to_other',},
                   
                   { :position => 16,  :column_name => 'vcpr_visit_care_plan_reviewed',},
                   
                   { :position => 20,  :column_name => 'mhex_mhealth_exit_reason',}
                   
                   ]);
    end
  end
    

  def self.down
    remove_column :claims_data, :ihd_heart_disease
    remove_column :claims_data, :resp_respiratory_illnesses
    remove_column :claims_data, :nurref_nutritionist_referral
  end
  
end
