class AddWphoEventReporting < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /wrpho|phocm/ )
      puts "Whanganui PHO - Significant Event Reporting"
      
      Programme.create_with_id 58, :code => 'SER', :description => 'Significant Event Reporting'

      FeeSchedule.create_with_id 5800, :programme_id => 58, :code => 'SE', :description => 'Significent Event', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

       ProgrammeElement.populate(58, [ 
                   { :position => 0,  :column_name => 'cont_contact_type', :report_by => 'count(claims.id)' }
                   ]);

    end
  end

  def self.down
  end
end
