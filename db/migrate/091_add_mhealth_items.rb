class AddMhealthItems < ActiveRecord::Migration
  def self.up
    #add_column :claims_data, :mhk10_mhealth_kessler_10, :string, :limit => 4
    
    add_column :claims_data, :mhphq9_mhealth_phq_9, :string, :limit => 2
    add_column :claims_data, :mhdx4_mhealth_diagnosis_4 , :string, :limit => 18
    add_column :claims_data, :mhdx5_mhealth_diagnosis_5 , :string, :limit => 18
    add_column :claims_data, :mhdx6_mhealth_diagnosis_6 , :string, :limit => 18
    
    ClaimsData.reset_column_information
    DataField.populate_table # Add new columns from claims_data 
    
    if ( Programme.exists?(8) )
    
      choices = [
          ['mhdx4_mhealth_diagnosis_4', "Abuse\r\nAlcohol Problem\r\nAnger\r\nAnxiety\r\nDepression\r\nIllicit drugs\r\nExercise\r\nSleep\r\nSmoking\r\nGambling\r\nOther"],
          ['mhdx5_mhealth_diagnosis_5', "Abuse\r\nAlcohol Problem\r\nAnger\r\nAnxiety\r\nDepression\r\nIllicit drugs\r\nExercise\r\nSleep\r\nSmoking\r\nGambling\r\nOther"],
          ['mhdx6_mhealth_diagnosis_6', "Abuse\r\nAlcohol Problem\r\nAnger\r\nAnxiety\r\nDepression\r\nIllicit drugs\r\nExercise\r\nSleep\r\nSmoking\r\nGambling\r\nOther"]
          ]
       choices.each do |choice|
          df=DataField.find_by_column_name(choice[0]);
          raise ArgumentError, "Data field not found '#{choice[0]}'"  if !df
          df.choices = choice[1];
          df.save!
       end          
  
      FeeSchedule.create_with_id 810, :programme_id => 8, :code => 'PMHCADS', :description => 'CADS', :fee => 0.00, :gl_account_no => '6-0000'
      FeeSchedule.create_with_id 811, :programme_id => 8, :code => 'PMHSMOK', :description => 'Smoking Cessation', :fee => 0.00, :gl_account_no => '6-0000'
      FeeSchedule.create_with_id 812, :programme_id => 8, :code => 'PMHOASI', :description => 'Oasis (Gambling)', :fee => 0.00, :gl_account_no => '6-0000'
  
      data = [ { :programme_id => 8, 
                  :elements => [ 
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
                    
                    { :position => 16, :column_name => 'copa_co_payment_amount'}
                  ]}
             ]
      
  
      data.each do |programme|
        ProgrammeElement.delete_all( { :programme_id => programme[:programme_id] })
        programme[:elements].each do |elem|
          e=ProgrammeElement.new(elem)
          e.programme_id = programme[:programme_id]
          e.save!
        end
      end
    end
  end

  def self.down
  end
end
