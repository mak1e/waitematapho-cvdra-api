class AddB4schoolNonResponder < ActiveRecord::Migration
  def self.up
    if (( Settings.database =~ /hhcm|phocm/ ) && ( Programme.exists?(6) ))
      puts "Updating b4school non responder (hhcm)"
      # Note hh codes and hbpho codes are different !!
      FeeSchedule.create_with_id 68, :programme_id => 6, :code => 'B4SCNR', :description => 'Non Responder', :fee => 0.00, :gl_account_no => '6-0000'
    end
  end

  def self.down
  end
end
