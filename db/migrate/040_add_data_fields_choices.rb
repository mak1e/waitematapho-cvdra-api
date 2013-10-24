class AddDataFieldsChoices < ActiveRecord::Migration
  def self.up
      DataField.populate_table
      
      choices = [
          ['a2ra_a2_receptor_antagonist', "Yes\r\nNo\r\nContra-indicated\r\nDeclined"],
          ['acar_acarbose', "Yes\r\nNo\r\nContra-indicated\r\nOn maximum tolerated dose\r\nDeclined"],
          ['acei_ace_inhibitor', "Yes\r\nNo\r\nContra-indicated\r\nDeclined"],
          ['actlim_activity_limitations', "No\r\nYes"],
          ['actplan_action_plan', "Give\r\nUsed"],
          ['angi_angina_ami', "No\r\nYes"],
          ['apst_albumin_protein_stick_test', "Negative\r\nPositive\r\nNot done\r\nNot required\r\nUnknown"],
          ['aspi_aspirin', "Yes\r\nNo\r\nContra-indicated\r\nDeclined"],
          ['atfi_atrial_fibrillation', "No\r\nYes"],
          ['beta_beta_blocker', "Yes\r\nNo\r\nContra-indicated\r\nDeclined"],
          ['bgsm_blood_glucose_self_monitoring', "Never\r\n< 1 test / day\r\n1-2 tests / day\r\n2-3 tests / day\r\n4+ tests / day"],
          ['caan_calcium_antagonist', "Yes\r\nNo\r\nContra-indicated\r\nDeclined"],
          ['clop_clopidogrel', "Yes\r\nNo\r\nContra-indicated\r\nDeclined"],
          ['diab_type_of_diabetes', "No diabetes\r\nType 1\r\nType 2\r\nType unknown\r\nGestational\r\nOther known type\r\nIGT / IFG\r\nDiabetes status unknown"],
          ['dsma_dipstick_test_for_microalbuminuria', "Negative\r\nPositive\r\nNot done\r\nNot applicable\r\nUnknown"],
          ['exaevi_exacarbation_emergency_visit', "0\r\n1\r\n2\r\n3\r\n4\r\n5\r\nNo\r\nYes"],
          ['exahos_exacarbation_hospital_admit', "0\r\n1\r\n2\r\n3\r\n4\r\n5\r\nNo\r\nYes"],
          ['exaost_exacarbation_oral_steriod', "0\r\n1\r\n2\r\n3\r\n4\r\n5\r\nNo\r\nYes"],
          ['eyer_eye_referral_today', "No\r\nNo - in screening programme\r\nNo - under ophthalmologist care\r\nYes to retinal screening programme\r\nYes to ophthalmologist\r\nNot required (eg blind)"],
          ['feetc_feet_circulation', "Not examined\r\nNormal\r\nAbnormal (Left)\r\nAbnormal (Right)\r\nAbnormal (BOTH)"],
          ['feets_feet_sensation', "Not examined\r\nNormal\r\nAbnormal (Left)\r\nAbnormal (Right)\r\nAbnormal (BOTH)"],
          ['fhcvd_family_history_early_cardiovascular_disease', "No\r\nYes"],
          ['fibra_fibrate', "Yes\r\nNo\r\nContra-indicated\r\nDeclined"],
          ['gld_genetic_lipid_disorder', "None\r\nFamilial hypercholestrolaemia\r\nFamilial defective apoB\r\nFamilial combined hypercholesterolaemia\r\nOther genetic lipid disorder"],
          ['glit_glitazone', "Yes\r\nNo\r\nContra-indicated\r\nOn maximum tolerated dose\r\nDeclined"],
          ['green_green_prescription', "Yes\r\nNo"],
          ['hdfu_history_diabetic_foot_ulcer', "Yes\r\nNo"],
          ['hypoa_hypoglycaemic_attacks', "Never\r\nLess than 1 per month\r\nLess than 1 per week\r\nMore than 1 per week"],
          ['inhtec_inhaler_technique', "Good\r\nMedium\r\nPoor"],
          ['insu_insulin', "No\r\nYes - Nocturnal only\r\nYes - Once daily\r\nYes - Twice daily\r\nYes - Multiple injections\r\nYes - Insulin pump\r\nYes - Other insulin (eg prn)\r\nYes"],
          ['lifet_lifestyle_therapy', "Declined\r\nYes\r\nNo"],
          ['macwe_maculopathy_worst_eye', "None\r\nMinimal\r\nMild\r\nMild+\r\nModerate\r\nSevere\r\nStable\r\nClarity / view inadequate\r\nUnknown"],
          ['medcon_medical_concordance', "Good\r\nMedium\r\nPoor"],
          ['metf_metformin', "Yes\r\nNo\r\nContra-indicated\r\nOn maximum tolerated dose\r\nDeclined"],
          ['mets_diagnosed_metabolic_syndrome', "No\r\nYes"],
          ['nirt_nicotine_replacement_therapy', "Yes\r\nNo\r\nContra-indicated\r\nDeclined"],
          ['oahm_other_anti_hypertensive_medication', "Yes\r\nNo\r\nContra-indicated\r\nDeclined"],
          ['ohrf_other_criteria_for_high_risk_foot', "No\r\nYes"],
          ['ollm_other_lipid_lowering_medication', "Yes\r\nNo\r\nContra-indicated\r\nDeclined"],
          ['pfmeter_peak_flow_meter', "No\r\nYes"],
          ['plla_previous_diabetic_lower_limb_amputation', "No\r\nYes - Left\r\nYes - Right\r\nYes - Bilateral\r\nYes"],
          ['preg_pregnant', "No\r\nYes"],
          ['ptca_ptca_cabg', "No\r\nYes"],
          ['pvd_peripheral_vessel_disease', "No\r\nYes"],
          ['renal_established_renal_disease', "No nephropathy\r\nConfirmed microalbuminuria\r\nOvert diabetic nephropathy\r\nNon diabetic nephropathy\r\nNot established"],
          ['retini_retinal_screening_interval', "Every 2 years\r\nEvery Year\r\nEvery 6 months\r\nOther\r\nNot required\r\nNot known"],
          ['retwe_retinopathy_worst_eye', "None\r\nMinimal\r\nMild\r\nModerate\r\nSevere\r\nProliferative\r\nStable\r\nPregnant no retinopathy"],
          ['sabause_short_acting_ba_usage', "Never\r\n2 less/week\r\n3 more/week\r\nEvery Day\r\n6+ Day"],
          ['smok_smoking_history', "No\r\nPast\r\nRecently quit\r\nYes - up to 10 / day\r\nYes - 11-19 / day\r\nYes - 20+ / day\r\nYes\r\nPassive"],
          ['statin_statin', "Yes\r\nNo\r\nContra-indicated\r\nDeclined"],
          ['sulp_sulphonylurea', "Yes\r\nNo\r\nContra-indicated\r\nOn maximum tolerated dose\r\nDeclined"],
          ['symday_symptoms_day', "None\r\n2 or less/week\r\n3 or more/week\r\nEvery Night"],
          ['symnig_symptoms_night', "None\r\n2 or less/week\r\n3 or more/week\r\nEvery Night"],
          ['thia_thiazide', "Yes\r\nNo\r\nContra-indicated\r\nDeclined"],
          ['tia_stroke_tia', "No\r\nYes"],
          ['warf_warfarin', "Yes\r\nNo\r\nContra-indicated\r\nDeclined"]]
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
