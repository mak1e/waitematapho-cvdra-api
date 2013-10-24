class AddWrphoPregnp < ActiveRecord::Migration
  def self.up
    #change_column :claims_data, :refft_referral_from_type, :string, :limit => 28
    #change_column :claims_data, :cont_contact_type, :string, :limit => 32
    ClaimsData.reset_column_information
    DataField.populate_table
    
    
    if ( Settings.database =~ /wrpho|phocm/ )
      puts "Whanganui PHO - Pregnancy and Parenting Education"
      
      Programme.create_with_id 47, :code => 'PNPE', :description => 'Pregnancy and Parenting Education'
      
      FeeSchedule.create_with_id 4700, :programme_id => 47, :code => 'EDU', :description => 'Education', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      ProgrammeElement.populate(47, [ 
                    { :position => 0, :column_name => 'supatt_support_person_attending'} ]);

          
          
    end    
  end

  def self.down
  end
end
