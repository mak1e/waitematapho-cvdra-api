class AddHbphoAsthma < ActiveRecord::Migration
  def self.up
    if (( Settings.database =~ /hbpho|phocm/ ))
      puts "Adding HBPHO Asthma"
      
      unless Programme.exists?(4)
          Programme.create_with_id 4, :code => 'ASTH', :description => 'Asthma'
      end
      FeeSchedule.create_with_id 45, :programme_id => 4, :code => 'GASPP', :description => 'Nurse Led Clinic', :is_the_default => true, :fee => 31.50, :gl_account_no => '6-9999'
      FeeSchedule.create_with_id 46, :programme_id => 4, :code => 'GASPN', :description => 'Non HBPHO', :fee => 0.00, :gl_account_no => '6-9999'
      FeeSchedule.create_with_id 47, :programme_id => 4, :code => 'GASPC', :description => 'Careplus',  :fee => 0.00, :gl_account_no => '6-9999'
      FeeSchedule.create_with_id 48, :programme_id => 4, :code => 'GASPO', :description => 'Other', :fee => 0.00, :gl_account_no => '6-9999'
    end
  end

  def self.down
  end
end
