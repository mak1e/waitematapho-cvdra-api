class AddHaurakiLtContraception < ActiveRecord::Migration
  
  def self.up
    add_column :claims_data, :reas_reason, :string, :limit => 18
    add_column :claims_data, :treat_treatment, :string, :limit => 18
    
    
    ClaimsData.reset_column_information
    DataField.populate_table

    if ( Settings.database =~ /haupho|phocm/ )
      puts "Hauraki PHO - Long Term Contraception"
      
      Programme.create_with_id 53, :code => 'LTC', :description => 'Long Term Contraception'

      FeeSchedule.create_with_id 5300, :programme_id => 53, :code => 'PRE', :description => 'Pre assessment', 
          :fee => 61.50, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 1, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 5301, :programme_id => 53, :code => 'IUDI', :description => 'IUD insertion', # Mirena
          :fee => 414.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      FeeSchedule.create_with_id 5302, :programme_id => 53, :code => 'IMPI', :description => 'Implant insertion', # Jadelle 
          :fee => 120.00, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0

      FeeSchedule.create_with_id 5303, :programme_id => 53, :code => 'FUP', :description => 'Follow-up', 
          :fee => 61.50, :gl_account_no => '0000-00',:is_the_default => false,
          :is_a_entry_service => 0, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0


       ProgrammeElement.populate(53, [ 
                   { :position => 0,  :column_name => 'refft_referral_from_type'},
                   { :position => 1,  :column_name => 'treat_treatment' },
                   { :position => 2,  :column_name => 'reas_reason'}
                   ]);
    end
  end
    

  def self.down
    remove_column :claims_data, :treat_treatment
    remove_column :claims_data, :reas_reason
  end


end
