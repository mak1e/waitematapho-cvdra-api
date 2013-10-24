class AddHbphoB4schoolView < ActiveRecord::Migration
  def self.up
    # Redo DSME Service Codes (Add Declined)
    if ( Programme.exists?(21) )
      puts "Updating DSME (harbourh)"
      
      FeeSchedule.delete_all( 'programme_id = 21' )
      
      FeeSchedule.create_with_id 2100, :programme_id => 21, :code => 'DSMEREF', :description => 'Referral', :fee => 0.00, :gl_account_no => '0000-00', :is_the_default => true, :is_a_entry_service => 1, :is_a_exit_service  => 0
      FeeSchedule.create_with_id 2101, :programme_id => 21, :code => 'DSMENOR', :description => 'Non Responder', :fee => 0.00, :gl_account_no => '0000-00', :is_a_entry_service => 0, :is_a_exit_service  => 1
      FeeSchedule.create_with_id 2102, :programme_id => 21, :code => 'DSMEDEC', :description => 'Declined', :fee => 0.00, :gl_account_no => '0000-00', :is_a_entry_service => 0, :is_a_exit_service  => 1
      FeeSchedule.create_with_id 2103, :programme_id => 21, :code => 'DSMEINC', :description => 'In Complete', :fee => 0.00, :gl_account_no => '0000-00', :is_a_entry_service => 0, :is_a_exit_service  => 1
      FeeSchedule.create_with_id 2104, :programme_id => 21, :code => 'DSMECOM', :description => 'Complete', :fee => 0.00, :gl_account_no => '0000-00', :is_a_entry_service => 0, :is_a_exit_service  => 1
    end
      
    if (( Settings.database =~ /hbpho|phocm/ ) && ( Programme.exists?(6) ))
      # Add view for Hawkes Bay PHO only. Want Referral Dates for Each Referral
      puts "Updating b4school elements and Change Fees/codes (hbpho)"
      
      FeeSchedule.delete_all( 'programme_id = 6' )
      
      FeeSchedule.create_with_id 60, :programme_id => 6, :code => 'B4SCC', :description => 'Practice Claim', :fee => 100.00, :gl_account_no => '6-0000'
      FeeSchedule.create_with_id 61, :programme_id => 6, :code => 'B4SCA', :description => 'Admin Claim', :fee => 25.00,  :gl_account_no => '6-0000'
      FeeSchedule.create_with_id 62, :programme_id => 6, :code => 'B4SNC', :description => 'No Claim', :fee => 0, :gl_account_no => '6-0000'
      # Add Outreach after discission with hbpho
      FeeSchedule.create_with_id 67, :programme_id => 6, :code => 'B4SOR', :description => 'Outreach', :fee => 0, :gl_account_no => '6-0000'
      
      FeeSchedule.create_with_id 69, :programme_id => 6, :code => 'B4SCD', :description => 'Declined', :fee => 10.00, :gl_account_no => '6-0000'
      
      data = [ { :programme_id => 6,
                 :elements => [
                  { :position => 0, :column_name => 'nokgn_nok_given_names'},
                  { :position => 1, :column_name => 'nokfn_nok_family_name'},
                  { :position => 2, :column_name => 'nokrel_nok_relationship'},
                  { :position => 4, :column_name => 'chqin_child_heath_q_interpretation'},
                  { :position => 8, :column_name => 'heig_height'},
                  { :position => 9, :column_name => 'weig_weight'},
                  { :position => 12, :column_name => 'bmi_body_mass_index'},
                  { :position => 13, :column_name => 'growin_growth_measure_interpretation'},
                  { :position => 16, :column_name => 'denten_dental_enrolled'},
                  { :position => 17, :column_name => 'dentent_dental_enrolled_today'},
                  { :position => 20, :column_name => 'dentde_dental_decay'},
                  { :position => 21, :column_name => 'dentin_dental_interpretation'},
                  { :position => 24, :column_name => 'vishs_vision_hearing_status'},
                  { :position => 28, :column_name => 'pedsss_peds_significant_score'},
                  { :position => 32, :column_name => 'pedsns_peds_non_significant_score'},
                  { :position => 33, :column_name => 'pedsin_peds_interpretation'},
                  { :position => 40, :column_name => 'sdqess_sdq_emotional_symptoms_score'},
                  { :position => 41, :column_name => 'sdqcps_sdq_conduct_problems_score'},
                  { :position => 42, :column_name => 'sdqhys_sdq_hyperactivity_score'},
                  { :position => 44, :column_name => 'sdqpps_sdq_peer_problems_score'},
                  { :position => 46, :column_name => 'sdqpbs_sdq_prosocial_behaviour_score'},
                  { :position => 48, :column_name => 'sdqtds_sdq_total_difficulties_score'},
                  { :position => 49, :column_name => 'sdqin_sdq_interpretation'},
                  { :position => 56, :column_name => 'imm4ud_4y_immunisation_up_to_date'},
                  { :position => 57, :column_name => 'immvt_immunisation_vacc_today'},
  
  
                  { :position => 60, :column_name => 'chqre_child_heath_q_referral'},
                  { :position => 61, :column_name => 'chqres_child_heath_q_referral_status'},
                  { :position => 62, :column_name => 'chqred_child_heath_q_referral_date'},
                  
                  { :position => 64, :column_name => 'growre_growth_measure_referral'},
                  { :position => 65, :column_name => 'growres_growth_measure_referral_status'},
                  { :position => 66, :column_name => 'growred_growth_measure_referral_date'},
                  
                  { :position => 68, :column_name => 'dentre_dental_referral'},
                  { :position => 69, :column_name => 'dentres_dental_referral_status'},
                  { :position => 70, :column_name => 'dentred_dental_referral_date'},

                  { :position => 72, :column_name => 'vishr_vision_hearing_referral'},
                  { :position => 73, :column_name => 'vishrs_vision_hearing_referral_status'},
                  { :position => 74, :column_name => 'vishrd_vision_hearing_referral_date'},
                 
                  { :position => 76, :column_name => 'pedsref_peds_referral'},
                  { :position => 77, :column_name => 'pedsrefs_peds_referral_status'},
                  { :position => 78, :column_name => 'pedsrefd_peds_referral_date'},

                  { :position => 80, :column_name => 'pedsref2_peds_referral_2'},
                  { :position => 81, :column_name => 'pedsref2s_peds_referral_2_status'},
                  { :position => 82, :column_name => 'pedsref2d_peds_referral_2_date'},
                  
                  { :position => 84, :column_name => 'sdqref_sdq_referral'},
                  { :position => 85, :column_name => 'sdqrefs_sdq_referral_status'},
                  { :position => 86, :column_name => 'sdqrefd_sdq_referral_date'},
                  
                  { :position => 88, :column_name => 'sdqref2_sdq_referral_2'},
                  { :position => 89, :column_name => 'sdqref2s_sdq_referral_2_status'},
                  { :position => 90, :column_name => 'sdqref2d_sdq_referral_2_date'},
                  
                  { :position => 92, :column_name => 'immre_immunisation_referral'},
                  { :position => 93, :column_name => 'immres_immunisation_referral_status'},
                  { :position => 94, :column_name => 'immred_immunisation_referral_date'}
  
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
