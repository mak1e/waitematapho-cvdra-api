class AddHhElecMh < ActiveRecord::Migration

  
  
  def self.up
    add_column :claims_data, :mhth_mh_therapy, :string, :limit => 18


    ClaimsData.reset_column_information
    DataField.populate_table
    choices = [
        ['mhth_mh_therapy', 
            "In House GP\r\ne-Therapy\r\nCBT Unstress Group\r\nClub Physical\r\nRaeburn House\r\n1:1 Therapy"]]
    choices.each do |choice|
        df=DataField.find_by_column_name(choice[0]);
        raise ArgumentError, "Data field not found '#{choice[0]}'"  if !df
        df.choices = choice[1];
        df.save!
    end
    
    if ( Programme.exists?(21) )
        puts "Updating Life style (MH)"
        
        FeeSchedule.create_with_id 820, :programme_id => 8, :code => 'PMETH', :description => 'e-Therapy', :fee => 120.00, :gl_account_no => '6-0000',
          :is_a_exit_service => 1, :is_a_entry_service => 1, :is_a_declined_service => 0, :is_the_default => false
      
        ProgrammeElement.populate(8, [ 
                    { :position => 0, :column_name => 'mhdx_mhealth_diagnosis'},
                    { :position => 1, :column_name => 'mhdx2_mhealth_diagnosis_2'},
                    { :position => 2, :column_name => 'mhdx3_mhealth_diagnosis_3'},
                    
                    { :position => 4, :column_name => 'mhdx4_mhealth_diagnosis_4'},
                    { :position => 5, :column_name => 'mhdx5_mhealth_diagnosis_5'},
                    { :position => 6, :column_name => 'mhdx6_mhealth_diagnosis_6'},
                    
                    { :position => 8, :column_name => 'mhth_mh_therapy' },
                    { :position => 9, :column_name => 'smok_smoking_history' },

                    { :position => 12, :column_name => 'mhphq9_mhealth_phq_9'},
                    { :position => 13, :column_name => 'mhgad7_mhealth_gad_7'},
                    { :position => 14, :column_name => 'mhk10_mhealth_kessler_10'},
                    { :position => 15, :column_name => 'qolr_quality_of_life_rating'},
                    
                    { :position => 16, :column_name => 'nosess_number_of_sessions'},
                    { :position => 17, :column_name => 'copa_co_payment_amount'}
                    ] )
                    
      ProgrammeElement.populate( 28, [ 
                  { :position => 0, :column_name => 'etcon_e_therapy_condition'},
                  
                  { :position => 4, :column_name => 'mhphq9_mhealth_phq_9'},
                  { :position => 5, :column_name => 'mhgad7_mhealth_gad_7'},
                  { :position => 6, :column_name => 'mhk10_mhealth_kessler_10'},
                  { :position => 7, :column_name => 'qolr_quality_of_life_rating'},
                  
                  { :position => 8, :column_name => 'nosess_number_of_sessions'}
                  ] )
                    
      
    end
    
  end

  def self.down
    remove_column :claims_data, :mhth_mh_therapy
  end
end
