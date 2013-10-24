class AddHaurakiIvSkinEtc < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /haupho|phocm/ )

      # =================================================================
      
      puts "Hauraki PHO - After Hours, programme_id #59"
      
      Programme.create_with_id 59, :code => 'AHR', :description => 'After Hours'

      FeeSchedule.create_with_id 5900, :programme_id => 59, :code => 'AHR', :description => 'After Hours', 
          :fee => 55.00, :gl_account_no => '00-0000',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0


      # =================================================================

      puts "Hauraki PHO - Sleep Apnoea -  programme id #60"

      Programme.create_with_id 60, :code => 'SAP', :description => 'Sleep Apnoea'

      
      FeeSchedule.create_with_id 6001, :programme_id => 60, :code => 'SAPA', :description => 'Assessment', :fee => 170.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,:is_the_default => true,
          :is_a_declined_service => 0, :is_a_dnr_service => 0


      ProgrammeElement.populate(60, [ 
                    { :position => 0, :column_name => 'cond_condition'}
                    ])          
      
      # =================================================================

      puts "Hauraki PHO - Heart Disease Monitoring - programme id #61"

      Programme.create_with_id 61, :code => 'HDM', :description => 'Heart Disease Monitoring'

      
      FeeSchedule.create_with_id 6101, :programme_id => 61, :code => 'ECG', :description => 'ECG - electrocardiogram', :fee => 50.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 6102, :programme_id => 61, :code => 'ETT', :description => 'ETT - Exercise tolerance', :fee => 170.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      # =================================================================
      
      puts "Hauraki PHO -  IV Infusions - programme id #62"

      Programme.create_with_id 62, :code => 'IVI', :description => 'IV Infusions'

      
      FeeSchedule.create_with_id 6201, :programme_id => 62, :code => 'ALC', :description => 'Alclasta', :fee => 150.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 6202, :programme_id => 62, :code => 'CIV', :description => 'Cellulitis IV', :fee => 150.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 6203, :programme_id => 62, :code => 'IRI', :description => 'Iron infusion', :fee => 150.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0


      # =================================================================
      
      puts "Hauraki PHO -  Extended Consultation - programme id #63"

      Programme.create_with_id 63, :code => 'EXCON', :description => 'Extended Consultation'

      
      FeeSchedule.create_with_id 6301, :programme_id => 63, :code => 'CONS', :description => 'Consult', :fee => 0.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1, :is_the_default => true,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      ProgrammeElement.populate(63, [{ :position => 0, :column_name => 'reas_reason'}])


      # =================================================================
      
      puts "Hauraki PHO -  Voucher - programme id #64"

      Programme.create_with_id 64, :code => 'VOUC', :description => 'Voucher'

      
      FeeSchedule.create_with_id 6401, :programme_id => 64, :code => 'FOOD', :description => 'Food', :fee => 0.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      FeeSchedule.create_with_id 6402, :programme_id => 64, :code => 'PETR', :description => 'Petrol', :fee => 0.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0


      ProgrammeElement.populate(64, [ 
                    { :position => 0, :column_name => 'vono_voucher_no'}
                    ])          
      
          
      # =================================================================
      
      puts "Hauraki PHO - Long Term Contraception, add Vasectomy "

      FeeSchedule.create_with_id 5304, :programme_id => 53, :code => 'VAS', :description => 'Vasectomy', 
          :fee => 350, :gl_account_no => '00-0000',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
          
      ProgrammeElement.populate(53, [ 
                    { :position => 0, :column_name => 'treat_treatment'},
                    { :position => 4, :column_name => 'reas_reason'}
                    ])          
      
      
      # =================================================================

      puts "Hauraki PHO - Community Based Podiatry - Services"
      
      unless ( Programme.exists?(23) )  
        Programme.create_with_id 23, :code => 'PODI', :description => 'Community Based Podiatry'
      end
      
        
      FeeSchedule.create_with_id 2310, :programme_id => 23, :code => 'PODPOD', :description => 'Podiatrist', :fee => 60.00, :gl_account_no => '00-0000',
            :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 0,
            :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 2311, :programme_id => 23, :code => 'PODNUR', :description => 'Nurse', :fee => 15.00, :gl_account_no => '00-0000',
            :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
            :is_a_declined_service => 0, :is_a_dnr_service => 0
  
      ProgrammeElement.populate(23, [ 
                    { :position => 0, :column_name => 'reas_reason'}
                    ])          

      # =================================================================

      puts "Hauraki PHO - Skin Lesion - Services"
      
      unless ( Programme.exists?(9) )  
        Programme.create_with_id 9, :code => 'SL', :description => 'Skin Lesions'
      end
      
      
      FeeSchedule.create_with_id 905, :programme_id => 9, :code => 'SLBIO', :description => 'Biopsy', :fee => 30.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 906, :programme_id => 9, :code => 'SLSUT', :description => 'Deep suturing', :fee => 350.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 907, :programme_id => 9, :code => 'SLNIT', :description => 'Liquid nitrogen', :fee => 30.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 908, :programme_id => 9, :code => 'SLSUR', :description => 'Low risk surgery', :fee => 200.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      ProgrammeElement.populate(9, [ 
                    { :position => 0, :column_name => 'cond_condition'}
                    ])          


      # =================================================================

      puts "Hauraki PHO - Care Plus,  programme_id #1"
      
      ProgrammeElement.populate(1, [ 
                    { :position => 0, :column_name => 'provt_provider_type'},
                    { :position => 4, :column_name => 'sbp_systolic_blood_pressure'},
                    { :position => 5, :column_name => 'dbp_diastolic_blood_pressure'},
                    { :position => 8, :column_name => 'weig_weight'},
                    { :position => 9, :column_name => 'heig_height'},
                    { :position => 10, :column_name => 'bmi_body_mass_index'}
                    ])
      
      # =================================================================

      puts "Hauraki PHO - CVD Check,  programme_id #2"

      FeeSchedule.update_all("fee = 28.75", "id=20")
      
      # =================================================================

      puts "Hauraki PHO - B4 School Check,  programme_id #6"
      
      unless ( Programme.exists?(6) )  
  
        Programme.create_with_id 6, :code => 'B4SC', :description => 'B4 School Check'
      
        FeeSchedule.create_with_id 60, :programme_id => 6, :code => 'B4SCC', :description => 'Practice Claim', :fee => 120.00, :gl_account_no => '00-0000',:is_the_default => true
      end
      
      # =================================================================
      
      puts "Hauraki PHO - High Priority Smear - Cervical Screening"
      
      unless ( Programme.exists?(27) )  
        Programme.create_with_id 27, :code => 'CXSM', :description => 'Cervical Screening'
        
        FeeSchedule.create_with_id 2700, :programme_id => 27, :code => 'COMP', :description => 'Completed', :fee => 20.00, :gl_account_no => '00-0000',:is_the_default => true,
            :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
            :is_a_declined_service => 0, :is_a_dnr_service => 0
      end
      
      ProgrammeElement.populate(27, [{ :position => 0, :column_name => 'reas_reason'}])

      # =================================================================
      
      puts "Hauraki PHO - U25 Sexual Health"
      
      # =================================================================
      
      puts "Hauraki PHO - SIA Pharmacy"
      
      unless ( Programme.exists?(5) )
        Programme.create_with_id 5, :code => 'SIA', :description => 'SIA'
      end
        
      FeeSchedule.create_with_id 510, :programme_id => 5, :code => 'SIARX', :description => 'Pharmacy Rx', :fee => 0.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 500, :programme_id => 5, :code => 'OTH', :description => 'Other', :fee => 0.00, :gl_account_no => '00-0000',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 511, :programme_id => 5, :code => 'SCH', :description => 'School Clinic', :fee => 0.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 512, :programme_id => 5, :code => 'U18', :description => 'Under 18', :fee => 0.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      # =================================================================

      puts "Hauraki PHO - MISC Claim"

      Programme.create_with_id 99, :code => 'MISC', :description => 'Miscellaneous Claim'

      FeeSchedule.create_with_id 9901, :programme_id => 99, :code => 'MISC', :description => 'Miscellaneous', :fee => 0.00, :gl_account_no => '00-0000',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 9902, :programme_id => 99, :code => 'RUBON', :description => 'Rural bonus', :fee => 0.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 9903, :programme_id => 99, :code => 'RURET', :description => 'Rural retention', :fee => 0.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 9905, :programme_id => 99, :code => 'TRDOC', :description => 'Training doctor', :fee => 0.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 9906, :programme_id => 99, :code => 'TRADM', :description => 'Training administration', :fee => 0.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 9907, :programme_id => 99, :code => 'TRNUR', :description => 'Training nurse', :fee => 0.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 9908, :programme_id => 99, :code => 'TROTH', :description => 'Training other', :fee => 0.00, :gl_account_no => '00-0000',
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0


    end
    
  end

  def self.down
       Programme.delete_all('id = 59')
       FeeSchedule.delete_all('id >= 5901 and id < 5909')
       Programme.delete_all('id = 60')
       FeeSchedule.delete_all('id >= 6001 and id < 6009')
       Programme.delete_all('id = 61')
       FeeSchedule.delete_all('id >= 6101 and id < 6109')
       Programme.delete_all('id = 62')
       FeeSchedule.delete_all('id >= 6201 and id < 6209')
       Programme.delete_all('id = 63')
       FeeSchedule.delete_all('id >= 6301 and id < 6309')
       Programme.delete_all('id = 64')
       FeeSchedule.delete_all('id >= 6401 and id < 6409')

       FeeSchedule.delete_all('id in ( 5304 )')
       FeeSchedule.delete_all('id in ( 2310, 2311 )')
       FeeSchedule.delete_all('id in ( 905, 906, 907, 908 )')    
       FeeSchedule.delete_all('id in ( 500, 510, 511, 512 )')    
       Programme.delete_all('id = 99')
       FeeSchedule.delete_all('id in ( 9901, 9902, 9903, 9905, 9906, 9907, 9908 )')    
  end
end
