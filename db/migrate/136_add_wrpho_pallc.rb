class AddWrphoPallc < ActiveRecord::Migration
  def self.up
    #change_column :claims_data, :refft_referral_from_type, :string, :limit => 28
    #change_column :claims_data, :cont_contact_type, :string, :limit => 32
    ClaimsData.reset_column_information
    DataField.populate_table
    
    
    if ( Settings.database =~ /wrpho|phocm/ )
      puts "Whanganui PHO - Community Palliative Care"
      
      Programme.create_with_id 45, :code => 'CPC', :description => 'Community Palliative Care'
      
      FeeSchedule.create_with_id 4500, :programme_id => 45, :code => 'NR', :description => 'New Referral', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      FeeSchedule.create_with_id 4501, :programme_id => 45, :code => 'FU', :description => 'Follow Up', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      ProgrammeElement.populate(45, [ 
                    { :position => 0, :column_name => 'refft_referral_from_type'},
                    { :position => 1, :column_name => 'dod_date_of_death'} ]);

          
          
    end    
  end

  def self.down
  end
end
