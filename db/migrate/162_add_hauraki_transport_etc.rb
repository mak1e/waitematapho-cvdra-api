class AddHaurakiTransportEtc < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /haupho|phocm/ )
      puts "Hauraki PHO - Transport Assistance"
      
      Programme.create_with_id 55, :code => 'TA', :description => 'Transport Assistance'

      FeeSchedule.create_with_id 5500, :programme_id => 55, :code => 'TADRIV', :description => 'Driver', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 5501, :programme_id => 55, :code => 'TAPETROL', :description => 'Petrol', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
    

       ProgrammeElement.populate(55, [ 
                   { :position => 0,  :column_name => 'conl_contact_location', :report_by => 'count(claims.id)' },
                   { :position => 1,  :column_name => 'km_kilometeres'},
                   
                   { :position => 4,  :column_name => 'refda_date_of_referral'},
                   { :position => 5,  :column_name => 'acc_acc_accident', :report_by => 'count(claims.id)' }
                   
                   ]);

      puts "Hauraki PHO - Minor Surgery"
      
      Programme.create_with_id 56, :code => 'MS', :description => 'Minor Surgery'

      FeeSchedule.create_with_id 5600, :programme_id => 56, :code => 'MSSMPL', :description => 'Simple', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 5601, :programme_id => 56, :code => 'MSCOM', :description => 'Complex', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 5602, :programme_id => 56, :code => 'MSBIO', :description => 'Biopsy', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
    

     if ( Settings.database =~ /phocm/ )
       Programme.delete_all('id = 17')
       FeeSchedule.delete_all('id in ( 1700,1701,1704)')
     end
      
      puts "Hauraki PHO - Palliative Care Visit" # Similar to Well Dunedin!!

      Programme.create_with_id 17, :code => 'PALC', :description => 'Palliative Care Visit'
      
      FeeSchedule.create_with_id 1700, :programme_id => 17, :code => 'PGPP', :description => 'GP Practice', :fee => 0.00, :gl_account_no => '0000-00', :is_the_default => true
      FeeSchedule.create_with_id 1701, :programme_id => 17, :code => 'PGPH', :description => 'GP Home Visit', :fee => 0.00, :gl_account_no => '0000-00'
      # FeeSchedule.create_with_id 1702, :programme_id => 17, :code => 'PNUP', :description => 'Nurse at Practice', :fee => 0.00, :gl_account_no => '60000-00'
      # FeeSchedule.create_with_id 1703, :programme_id => 17, :code => 'PNUH', :description => 'Nurse Home Visit', :fee => 0.00, :gl_account_no => '0000-00'
      FeeSchedule.create_with_id 1704, :programme_id => 17, :code => 'PGPHX', :description => 'GP Home Visit (Extended)', :fee => 0.00, :gl_account_no => '0000-00'
      
    end
    
  end

  def self.down
    if ( Settings.database =~ /haupho|phocm/ )
       Programme.delete_all('id = 55')
       FeeSchedule.delete_all('id in ( 5500,5501)')

       Programme.delete_all('id = 56')
       FeeSchedule.delete_all('id in ( 5600,5601,5602)')
       
       Programme.delete_all('id = 17')
       FeeSchedule.delete_all('id in ( 1700,1701,1704)')
      
    end
  end
end
