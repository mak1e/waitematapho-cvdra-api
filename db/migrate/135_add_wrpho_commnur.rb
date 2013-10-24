class AddWrphoCommnur < ActiveRecord::Migration
  def self.up
    change_column :claims_data, :refft_referral_from_type, :string, :limit => 28
    change_column :claims_data, :cont_contact_type, :string, :limit => 32
    ClaimsData.reset_column_information
    DataField.populate_table
    
    
    if ( Settings.database =~ /wrpho|phocm/ )
      puts "Whanganui PHO - Community District Nursing"
      
      Programme.create_with_id 44, :code => 'CDN', :description => 'Community District Nursing'
      
      FeeSchedule.create_with_id 4400, :programme_id => 44, :code => 'GEN', :description => 'General/Specialist', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 4401, :programme_id => 44, :code => 'PDX', :description => 'Post Dx', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 4402, :programme_id => 44, :code => 'ACC', :description => 'ACC Community', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      ProgrammeElement.populate(44, [ 
                    { :position => 0, :column_name => 'refft_referral_from_type'},
                    { :position => 1, :column_name => 'cont_contact_type'}])
          
    end    
    
  end

  def self.down
  end
end
