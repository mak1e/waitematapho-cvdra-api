class AddWdunPuketai < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /phocm/ )
      # Add Puketai that Well Dunedin Has set-up
      puts "Adding Puketai Well Dunedin"
      

      # Diabetes Self Management Education for Harbour Health
      Programme.create_with_id 34, :code => 'PUKE', :description => 'Puketai'
      
      # Well dunedin import is at file:///\\florence\HLINK\phocmimport\phocmimport.exe
      
      FeeSchedule.create_with_id 3400, :programme_id => 34, :code => 'PMA', :description => 'Medical Assessment', :fee => 120.00, :gl_account_no => '0000-00'
      FeeSchedule.create_with_id 3401, :programme_id => 34, :code => 'PRC', :description => 'Regular Consultation', :fee => 46.00, :gl_account_no => '0000-00'
      FeeSchedule.create_with_id 3402, :programme_id => 34, :code => 'PPR', :description => 'Prescription Request', :fee => 14.00, :gl_account_no => '0000-00'
      FeeSchedule.create_with_id 3403, :programme_id => 34, :code => 'POS', :description => 'Other Service', :fee => 0.00, :gl_account_no => '0000-00'
      
    end
  end

  def self.down
    Programme.delete_all( 'id = 34' )
    FeeSchedule.delete_all( 'programme_id = 34' )
    ProgrammeElement.delete_all( 'programme_id = 34' )
  end
end
