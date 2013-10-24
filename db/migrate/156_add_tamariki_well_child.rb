class AddTamarikiWellChild < ActiveRecord::Migration
  
  def self.up
    if ( Settings.database =~ /haupho|phocm/ )
      puts "Hauraki PHO - Tamariki Well Child"
      
      Programme.create_with_id 54, :code => 'TWC', :description => 'Tamariki Well Child'

      
      FeeSchedule.create_with_id 5400, :programme_id => 54, :code => 'ENR', :description => 'Enrollment', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 5401, :programme_id => 54, :code => 'CON', :description => 'Follow-up', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
    
      FeeSchedule.create_with_id 5402, :programme_id => 54, :code => 'EXI', :description => 'Exit/Discharge', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      

       ProgrammeElement.populate(54, [ 
                   { :position => 0,  :column_name => 'conl_contact_location'},
                   
                   { :position => 4,  :column_name => 'pedsref_peds_referral'},
                   { :position => 5,  :column_name => 'growre_growth_measure_referral'},
                   { :position => 6,  :column_name => 'vishr_vision_hearing_referral'},
                   
                   { :position => 8,  :column_name => 'imm4ud_4y_immunisation_up_to_date'},
                   
                   { :position => 12,  :column_name => 'refto_referral_to_other'},
                   { :position => 13,  :column_name => 'smref_smoking_action_referral'}
                   ]);

        DataField.update_all("label='Immunisation Up To Date'","column_name='imm4ud_4y_immunisation_up_to_date'");
        DataField.update_all("label='PEDS/Development Referral'","column_name='pedsref_peds_referral'");
        DataField.update_all("label='Smoking Referral'","column_name='smref_smoking_action_referral'");
    end
  end

  def self.down
  end
end
