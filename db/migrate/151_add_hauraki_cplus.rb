class AddHaurakiCplus < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /haupho|phocm/ )
       puts "Hauraki PHO - Care Plus,  programme_id #1"

      FeeSchedule.update_all("description = 'Enrolment', fee = 102.00", "id=10")
      FeeSchedule.update_all("description = 'Quarterly Review', fee = 50.00", "id=11")
      FeeSchedule.create_with_id 12, :programme_id => 1, :code => 'CPDE', :description => 'Disenrolment', :fee => 50.00 , :gl_account_no => '00-000000'
      FeeSchedule.create_with_id 13, :programme_id => 1, :code => 'CPDN', :description => 'Disenrolment (no Review)', :fee => 0.00 , :gl_account_no => '00-000000'
    end
    
    ProgrammeElement.populate(1, [ 
                    { :position => 0, :column_name => 'sbp_systolic_blood_pressure'},
                    { :position => 1, :column_name => 'dbp_diastolic_blood_pressure'},
                    { :position => 4, :column_name => 'weig_weight'},
                    { :position => 5, :column_name => 'heig_height'},
                    { :position => 6, :column_name => 'bmi_body_mass_index'}])
                    
    
  end

  def self.down
  end
end
