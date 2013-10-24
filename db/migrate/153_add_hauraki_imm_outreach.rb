class AddHaurakiImmOutreach < ActiveRecord::Migration
  def self.up

    add_column :claims_data, :km_kilometeres, :integer
    
    ClaimsData.reset_column_information
    DataField.populate_table
    
    if ( Settings.database =~ /haupho|phocm/ )
      puts "Hauraki PHO - Outreach Immunisations"
      
      Programme.create_with_id 51, :code => 'IOR', :description => 'Immunisation Outreach'

      FeeSchedule.create_with_id 5100, :programme_id => 51, :code => 'VACC', :description => 'Vaccination', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 5101, :programme_id => 51, :code => 'DEC', :description => 'Declined', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 1, :is_a_dnr_service => 0
    
      FeeSchedule.create_with_id 5102, :programme_id => 51, :code => 'DNR', :description => 'Non Responder', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 1
    
      FeeSchedule.create_with_id 5103, :programme_id => 51, :code => 'DNA', :description => 'Did Not Attend', 
          :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

    
       ProgrammeElement.populate(51, [ 
                   { :position => 0,  :column_name => 'conl_contact_location'},
                   { :position => 1,  :column_name => 'km_kilometeres'},
                   
                   { :position => 4,  :column_name => 'immvt_immunisation_vacc_today'}
                   
                   ]);
                   
       df=DataField.find_by_column_name('conl_contact_location');
       df.choices = "At home\r\nCommunity setting\r\nAt surgery";
       df.save!
                   
       df=DataField.find_by_column_name('immvt_immunisation_vacc_today');
       df.choices = "4 year\r\n15 month\r\n5 month\r\n3 month\r\n6 week\r\nYes";
       df.save!
                       
    
    end
  end


  def self.down
    remove_column :claims_data, :km_kilometeres
  end
end
