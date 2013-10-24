class AddWhangSmoking < ActiveRecord::Migration
  def self.up
    # add_column :claims_data, :smok_smoking_history, :string, :limit => 18
    # add_column :claims_data, :smpy_smoking_pack_years, :integer
    
    add_column :claims_data, :smready_smoking_readiness_quit, :string, :limit => 32
    add_column :claims_data, :smhou_smoking_household, :string, :limit => 32
    add_column :claims_data, :smref_smoking_action_referral, :string, :limit => 32

    add_column :claims_data, :smpatrx_smoking_patch_rx, :string, :limit => 18
    add_column :claims_data, :smgumrx_smoking_gum_rx, :string, :limit => 18
    add_column :claims_data, :smothrx_smoking_other_rx, :string, :limit => 28
    add_column :claims_data, :smquit_smoking_quit_status, :string, :limit => 32

    ClaimsData.reset_column_information
    DataField.populate_table
    
    choices = [
    ['smgumrx_smoking_gum_rx',"Gum\r\nLozenge\r\nGum 2 mg\r\nGum 4 mg\r\nLozenge 1 mg\r\nLozenge 2mg"],
    ['smpatrx_smoking_patch_rx',"Patch\r\nPatch 7 mg\r\nPatch 14 mg\r\nPatch 21 mg"],
    ['smothrx_smoking_other_rx',"Bupropion\r\nNortriptyline\r\nVarenicline\r\nBupropion Tab 150 mg\r\nNortriptyline Tab 10 mg\r\nNortriptyline Tab 20 mg"]
    ]
    
     choices.each do |choice|
        df=DataField.find_by_column_name(choice[0]);
        raise ArgumentError, "Data field not found '#{choice[0]}'"  if !df
        df.choices = choice[1];
        df.save!
     end        
    
   if ( Settings.database == 'wrpho')
      puts "Creating Smoking Cessation (wrpho)"
      
      # Add Smoking Cessation for whanganui regional pho
      Programme.create_with_id 20, :code => 'SCSWR', :description => 'Smoking Cessation'
      
      FeeSchedule.create_with_id 2000, :programme_id => 20, :code => 'SCINI', :description => 'Initial', :fee => 45.00, :gl_account_no => '0000-00', :is_the_default => true
      FeeSchedule.create_with_id 2001, :programme_id => 20, :code => 'SCF2F', :description => 'Face To Face', :fee => 30.00, :gl_account_no => '0000-00'
      FeeSchedule.create_with_id 2002, :programme_id => 20, :code => 'SCPHO', :description => 'Phone', :fee => 20.00, :gl_account_no => '0000-00'
      FeeSchedule.create_with_id 2003, :programme_id => 20, :code => 'SCSTA', :description => 'Status', :fee => 10.00, :gl_account_no => '0000-00'
      FeeSchedule.create_with_id 2004, :programme_id => 20, :code => 'SCNOC', :description => 'No Claim', :fee => 0.00, :gl_account_no => '0000-00'
      
      ProgrammeElement.populate(20, [ 
                    { :position => 0,  :column_name => 'smok_smoking_history'},
                    { :position => 1,  :column_name => 'smpy_smoking_pack_years'},
                    
                    { :position => 4,  :column_name => 'smready_smoking_readiness_quit'},
                    { :position => 5,  :column_name => 'smhou_smoking_household'},
                    
                    { :position => 8,  :column_name => 'smref_smoking_action_referral'},
                    
                    { :position => 12,  :column_name => 'smquit_smoking_quit_status'},
                    
                    { :position => 16,  :column_name => 'smpatrx_smoking_patch_rx'},
                    { :position => 17,  :column_name => 'smgumrx_smoking_gum_rx'},
                    { :position => 18,  :column_name => 'smothrx_smoking_other_rx'}
                    ])
      
    end
  end

  def self.down
    remove_column :claims_data, :smready_smoking_readiness_quit
    remove_column :claims_data, :smhou_smoking_household
    remove_column :claims_data, :smref_smoking_action_referral

    remove_column :claims_data, :smpatrx_smoking_patch_rx
    remove_column :claims_data, :smgumrx_smoking_gum_rx
    remove_column :claims_data, :smothrx_smoking_other_rx
    remove_column :claims_data, :smquit_smoking_quit_status


    ClaimsData.reset_column_information
    DataField.populate_table    
    
    Programme.delete_all( 'id = 20')
    FeeSchedule.delete_all( 'programme_id = 20')    
    ProgrammeElement.delete_all( 'programme_id = 20')    
    
  end
end
