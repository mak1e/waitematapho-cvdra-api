class AddWrphoSmokingV2 < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /wrpho|phocm/ )
      puts "Whanganui PHO - Smoking V2 (In Consult vs Dedicated Consult)"

      FeeSchedule.create_with_id 2006, :programme_id => 20, :code => 'SCINI2', :description => 'Initial (Dedicated)', :fee => 0.00, :gl_account_no => '0000-00'
      FeeSchedule.create_with_id 2007, :programme_id => 20, :code => 'SCF2F2', :description => 'Face To Face (Dedicated)', :fee => 0.00, :gl_account_no => '0000-00'
    end    
  end

  def self.down
  end
end
