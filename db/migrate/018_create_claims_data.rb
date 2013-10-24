class CreateClaimsData < ActiveRecord::Migration
 def self.up
    create_table :claims_data, { :id => false  } do |t|
      t.integer :id, :null => false
      
      t.integer :heig_height # Height  V1
      t.integer :weig_weight # Weight  V1
      t.integer :bmi_body_mass_index
      t.integer :waist_waist_circumference # Waist Circumference
      t.string :smok_smoking_history, :limit => 18  # Smoking History
      t.string :diab_type_of_diabetes, :limit => 18  # Type Of Diabetes
      t.integer :yodd_year_of_diabetes_diagnosis # Year Of Diabetes Diagnosis

      t.string :hoac_history_of_acute_coronary_syndrome, :limit => 18 # History Of Acute Coronary Syndrome
      t.string :angi_angina_ami, :limit => 18 # Angina-AMI
      t.string :ptca_ptca_cabg, :limit => 18 # PTCA-CABG
      t.string :tia_stroke_tia, :limit => 18 # Stroke-TIA
      t.string :pvd_peripheral_vessel_disease, :limit => 18 # Peripheral Vessel Disease
      t.string :fhcvd_family_history_early_cardiovascular_disease, :limit => 18 # Family History of Premature CVD
      t.string :gld_genetic_lipid_disorder, :limit => 18  # Genetic Lipid Disorder
      t.string :renal_established_renal_disease, :limit => 18  # Established Renal Disease
      t.string :atfi_atrial_fibrillation, :limit => 18 # Atrial Fibrillation
      t.string :mets_diagnosed_metabolic_syndrome, :limit => 18 # Diagnosed Metabolic Syndrome
      t.string :preg_pregnant, :limit => 18 # Pregnant

      t.integer :sbp_systolic_blood_pressure # Systolic Blood Pressure Today V1
      t.integer :dbp_diastolic_blood_pressure # Diastolic Blood Pressure Today V1
      t.integer :sbpp_systolic_blood_pressure_previous # Systolic Blood Pressure Previous
      t.integer :dbpp_diastolic_blood_pressure_previous # Diastolic Blood Pressure Previous
      t.decimal :cvdr_cvd_risk, :precision => 8, :scale => 2 # CVD Risk

      t.decimal :gluc_fasting_glucose, :precision => 8, :scale => 2 # Fasting Glucose
#     t.date    :glucd_fasting_glucose_date # Fasting Glucose Date
      t.decimal :tc_total_cholesterol, :precision => 8, :scale => 2 # Total Cholesterol  V1
#     t.date    :tcd_total_cholesterol_date # Total Cholesterol Date
      t.decimal :hdl_hdl_cholesterol, :precision => 8, :scale => 2 # HDL Cholesterol V1
      t.decimal :ldl_ldl_cholesterol, :precision => 8, :scale => 2 # LDL Cholesterol
      t.decimal :trig_triglyceride, :precision => 8, :scale => 2 # Triglyceride V1
      t.decimal :tchdl_tc_hdl_ratio, :precision => 8, :scale => 2 # TC:HDL Cholesterol Ratio
      t.decimal :creat_serum_creatinine, :precision => 8, :scale => 2 # Serum Creatinine
#     t.date    :creatd_serum_creatinine_date # Serum Creatinine Date
      t.string  :egfr_glumeral_filtration, :limit => 18 # eGFR
      t.decimal :acr_urine_albumin_to_creatine_ratio, :precision => 8, :scale => 2 # Urine Albumin To Creatine Ratio  V1
#     t.date    :acrd_urine_albumin_to_creatine_ratio_date # Urine ACR Date
      t.string  :dsma_dipstick_test_for_microalbuminuria, :limit => 18  # Dipstick Test For Microalbuminuria  V1
      t.string  :apst_albumin_protein_stick_test, :limit => 18  # Albumin Protein Stick Test

      t.decimal :hba1c_hba1c, :precision => 8, :scale => 2 # HbA1c V1
#     t.date    :hba1cd_hba1c_date # HbA1c Date
      t.date    :retind_date_last_retinal_screening # Date Last Retinal Screening  V1
      t.string  :retini_retinal_screening_interval, :limit => 18  # Retinal Screening Interval
      
      t.string :aspi_aspirin, :limit => 18  # Aspirin
      t.string :clop_clopidogrel, :limit => 18  # Clopidogrel
      t.string :warf_warfarin, :limit => 18  # Warfarin
      t.string :acei_ace_inhibitor, :limit => 18  # ACE Inhibitor V1
      t.string :a2ra_a2_receptor_antagonist, :limit => 18  # A2 Receptor Antagonist

      t.string :beta_beta_blocker, :limit => 18  # Beta Blocker
      t.string :thia_thiazide, :limit => 18  # Thiazide
      t.string :caan_calcium_antagonist, :limit => 18  # Calcium Antagonist
      t.string :oahm_other_anti_hypertensive_medication, :limit => 18  # Other Anti Hypertensive Medication V1
      t.string :statin_statin, :limit => 18  # Statin V1
      t.string :fibra_fibrate, :limit => 18  # Fibrate
      t.string :ollm_other_lipid_lowering_medication, :limit => 18  # Other Lipid Lowering Medication V1
      t.string :nirt_nicotine_replacement_therapy, :limit => 18  # Nicotine Replacement Therapy
      t.string :lifet_lifestyle_therapy, :limit => 18 # Diet Lifestyle Therapy

      t.string :green_green_prescription, :limit => 18  # Green Prescription
      t.string :insu_insulin, :limit => 18  # Insulin V1
      t.string :metf_metformin, :limit => 18  # Metformin
      t.string :sulp_sulphonylurea, :limit => 18  # Sulphonylurea
      t.string :glit_glitazone, :limit => 18  # Glitazone
      t.string :acar_acarbose, :limit => 18  # Acarbose

      t.string :eyer_eye_referral_today, :limit => 18  # Eye Referral Today
      t.string :vacl_visual_acuity_left, :limit => 18 # Visual Acuity Left
      t.string :vacr_visual_acuity_right, :limit => 18 # Visual Acuity Right
      t.string :retwe_retinopathy_worst_eye, :limit => 18 # Retinopathy Worst Eye
      t.string :macwe_maculopathy_worst_eye, :limit => 18 # Maculopathy Worst Eye
      t.string :feets_feet_sensation, :limit => 18 # Feet Sensation
      t.string :feetc_feet_circulation, :limit => 18 # Feet Circulation
      t.string :hdfu_history_diabetic_foot_ulcer, :limit => 18  # History Diabetic Foot Ulcer
      t.string :cdfu_current_diabetic_foot_ulcer, :limit => 18  # Current Diabetic Foot Ulcer
      t.string :ohrf_other_criteria_for_high_risk_foot, :limit => 18  # Other Criteria For High Risk Foot
      
      t.string :plla_previous_diabetic_lower_limb_amputation, :limit => 18  # Previous Diabetic Lower Limb Amputation
      t.string :hypoa_hypoglycaemic_attacks, :limit => 18  # Hypoglycaemic Attacks
      t.string :bgsm_blood_glucose_self_monitoring, :limit => 18  # Blood Glucose Self Monitoring
      
      t.string :refto_Referral_To, :limit => 18  # Referral To
    end
    execute "alter table claims_data add primary key (id)"
  end

  def self.down
    drop_table :claims_data
  end
end
