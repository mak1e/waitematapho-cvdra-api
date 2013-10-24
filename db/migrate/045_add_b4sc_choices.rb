class AddB4scChoices < ActiveRecord::Migration
  def self.up
      DataField.populate_table
      
     
      choices = [
          ['chqin_child_heath_q_interpretation', "No Concern\r\nMinor Concern\r\nSignificant Concern\r\nDeclined"],
          ['chqre_child_heath_q_referral', "General practice\r\nHealth specialist\r\nDeclined"],
          ['chqres_child_heath_q_referral_status', "Actioned\r\nDeclined"],
          
          ['imm4ud_4y_immunisation_up_to_date', "Yes\r\nNo\r\nPartial\r\nDeclined"],
          ['immvt_immunisation_vacc_today', "Yes"],
          ['immre_immunisation_referral', "General practice\r\nPlunket\r\nImm Outreach\r\nDeclined"],
          ['immres_immunisation_referral_status', "Actioned\r\nDeclined"],
          
          ['growin_growth_measure_interpretation', "No Concern\r\nMinor Concern\r\nSignificant Concern\r\nDeclined"],
          ['growre_growth_measure_referral', "General practice\r\nHealth specialist\r\nPublic health nurse\r\nGreen Rx\r\nDeclined"],
          ['growres_growth_measure_referral_status', "Actioned\r\nDeclined"],
          
          ['dentde_dental_decay', "1\r\n2\r\n3\r\n4\r\n5\r\n6"],
          ['denten_dental_enrolled', "Yes\r\nNo"],
          ['dentent_dental_enrolled_today', "Yes"],
          ['dentin_dental_interpretation', "No Concern\r\nMinor Concern\r\nSignificant Concern\r\nDeclined"],
          ['dentre_dental_referral', "School Dental Service\r\nDentist\r\nDeclined"],
          ['dentres_dental_referral_status', "Actioned\r\nDeclined"],
          
          ['vishs_vision_hearing_status', "Completed\r\nPending\r\nMissed\r\nDeclined"],
          ['vishr_vision_hearing_referral', "Vision and Hearing\r\nDeclined"],
          ['vishrs_vision_hearing_referral_status', "Actioned\r\nDeclined"],
          
          ['pedsin_peds_interpretation', "Two+ Significant Concerns\r\nOne Significant Concern\r\nMinor Concern\r\nCommunication Difficulty\r\nNo Concern\r\nDeclined"],
          ['pedsref_peds_referral', "General practice\r\nHealth specialist\r\nSecondary Screen\r\nAudiology\r\nSpeech Therapy\r\nCognitive Behaviour\r\nAges and Stages Q\r\nPublic health nurse\r\nDeclined"],
          ['pedsrefs_peds_referral_status', "Actioned\r\nDeclined"],
          ['pedsref2_peds_referral_2', "General practice\r\nHealth specialist\r\nSecondary Screen\r\nAudiology\r\nSpeech Therapy\r\nCognitive Behaviour\r\nAges and Stages Q\r\nPublic health nurse\r\nDeclined"],
          ['pedsref2s_peds_referral_2_status', "Actioned\r\nDeclined"],
          
          ['sdqin_sdq_interpretation', "No Concern\r\nMinor Concern\r\nSignificant Concern\r\nDeclined"],
          ['sdqref_sdq_referral', "General practice\r\nPaediatrician\r\nMental Health Specialist\r\nGroup Special Education\r\nParenting Programme\r\nPublic health nurse\r\nDeclined"],
          ['sdqrefs_sdq_referral_status', "Actioned\r\nDeclined"],
          ['sdqref2_sdq_referral_2', "General practice\r\nPaediatrician\r\nMental Health Specialist\r\nGroup Special Education\r\nParenting Programme\r\nPublic health nurse\r\nDeclined"],
          ['sdqref2s_sdq_referral_2_status', "Actioned\r\nDeclined"],
          
          ['nokrel_nok_relationship', "Mother\r\nFather\r\nGuardian\r\nOther"]
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
