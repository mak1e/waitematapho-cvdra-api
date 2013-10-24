class AddMhealthChoices < ActiveRecord::Migration
  def self.up
      DataField.populate_table
      
      choices = [
          ['mhdx_mhealth_diagnosis', "Abuse\r\nAlcohol Problem\r\nAnger\r\nAnxiety\r\nDepression\r\nIllicit drugs\r\nExercise\r\nSleep\r\nSmoking\r\nGambling\r\nOther"],
          ['mhdx2_mhealth_diagnosis_2', "Abuse\r\nAlcohol Problem\r\nAnger\r\nAnxiety\r\nDepression\r\nIllicit drugs\r\nExercise\r\nSleep\r\nSmoking\r\nGambling\r\nOther"],
          ['mhdx3_mhealth_diagnosis_3', "Abuse\r\nAlcohol Problem\r\nAnger\r\nAnxiety\r\nDepression\r\nIllicit drugs\r\nExercise\r\nSleep\r\nSmoking\r\nGambling\r\nOther"],
          ['qolr_quality_of_life_rating', "00-14\r\n15-24\r\n25-49\r\n50-74\r\n75+"]
          ]
          
       choices.each do |choice|
          df=DataField.find_by_column_name(choice[0]);
          raise ArgumentError, "Data field not found '#{choice[0]}'"  if !df
          df.choices = choice[1];
          df.save!
       end
  end

  def self.down
  end
end
