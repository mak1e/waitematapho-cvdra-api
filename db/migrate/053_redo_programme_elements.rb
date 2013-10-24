class RedoProgrammeElements < ActiveRecord::Migration
  def self.up
  data = [ { :programme_id => 2, 
              :elements => [ 
                { :position => 0, :column_name => 'cvdr_cvd_risk'},
                { :position => 1, :column_name => 'diab_type_of_diabetes'},
                { :position => 4, :column_name => 'angi_angina_ami'},
                { :position => 5, :column_name => 'tia_stroke_tia'},
                { :position => 6, :column_name => 'pvd_peripheral_vessel_disease'},
                { :position => 8, :column_name => 'atfi_atrial_fibrillation'},
                { :position => 9, :column_name => 'mets_diagnosed_metabolic_syndrome'},
                { :position => 10, :column_name => 'gld_genetic_lipid_disorder'}
              ]},
           { :programme_id => 3, 
              :elements => [                 
                { :position => 0, :column_name => 'diab_type_of_diabetes'},
                { :position => 1, :column_name => 'retind_date_last_retinal_screening'},
                { :position => 4, :column_name => 'hba1c_hba1c'},
                { :position => 5, :column_name => 'tc_total_cholesterol'},
                { :position => 8, :column_name => 'acei_ace_inhibitor'},
                { :position => 9, :column_name => 'statin_statin'}
              
              ]},
           { :programme_id => 6, 
              :elements => [                 
                { :position => 0, :column_name => 'nokgn_nok_given_names'},
                { :position => 1, :column_name => 'nokfn_nok_family_name'},
                { :position => 2, :column_name => 'nokrel_nok_relationship'},
                { :position => 4, :column_name => 'chqin_child_heath_q_interpretation'},
                { :position => 6, :column_name => 'chqre_child_heath_q_referral'},
                { :position => 7, :column_name => 'chqres_child_heath_q_referral_status'},
                { :position => 8, :column_name => 'heig_height'},
                { :position => 9, :column_name => 'weig_weight'},
                { :position => 12, :column_name => 'bmi_body_mass_index'},
                { :position => 13, :column_name => 'growin_growth_measure_interpretation'},
                { :position => 14, :column_name => 'growre_growth_measure_referral'},
                { :position => 15, :column_name => 'growres_growth_measure_referral_status'},
                { :position => 16, :column_name => 'denten_dental_enrolled'},
                { :position => 17, :column_name => 'dentent_dental_enrolled_today'},
                { :position => 20, :column_name => 'dentde_dental_decay'},
                { :position => 21, :column_name => 'dentin_dental_interpretation'},
                { :position => 22, :column_name => 'dentre_dental_referral'},
                { :position => 23, :column_name => 'dentres_dental_referral_status'},
                { :position => 24, :column_name => 'vishs_vision_hearing_status'},
                { :position => 26, :column_name => 'vishr_vision_hearing_referral'},
                { :position => 27, :column_name => 'vishrs_vision_hearing_referral_status'},
                { :position => 28, :column_name => 'pedsss_peds_significant_score'},
                { :position => 32, :column_name => 'pedsns_peds_non_significant_score'},
                { :position => 33, :column_name => 'pedsin_peds_interpretation'},
                { :position => 34, :column_name => 'pedsref_peds_referral'},
                { :position => 35, :column_name => 'pedsrefs_peds_referral_status'},
                { :position => 38, :column_name => 'pedsref2_peds_referral_2'},
                { :position => 39, :column_name => 'pedsref2s_peds_referral_2_status'},
                { :position => 40, :column_name => 'sdqess_sdq_emotional_symptoms_score'},
                { :position => 41, :column_name => 'sdqcps_sdq_conduct_problems_score'},
                { :position => 42, :column_name => 'sdqhys_sdq_hyperactivity_score'},
                { :position => 44, :column_name => 'sdqpps_sdq_peer_problems_score'},
                { :position => 46, :column_name => 'sdqpbs_sdq_prosocial_behaviour_score'},
                { :position => 48, :column_name => 'sdqtds_sdq_total_difficulties_score'},
                { :position => 49, :column_name => 'sdqin_sdq_interpretation'},
                { :position => 50, :column_name => 'sdqref_sdq_referral'},
                { :position => 51, :column_name => 'sdqrefs_sdq_referral_status'},
                { :position => 54, :column_name => 'sdqref2_sdq_referral_2'},
                { :position => 55, :column_name => 'sdqref2s_sdq_referral_2_status'},
                { :position => 56, :column_name => 'imm4ud_4y_immunisation_up_to_date'},
                { :position => 57, :column_name => 'immvt_immunisation_vacc_today'},
                { :position => 58, :column_name => 'immre_immunisation_referral'},
                { :position => 59, :column_name => 'immres_immunisation_referral_status'}
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

  def self.down
  end
end
