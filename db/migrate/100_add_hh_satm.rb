class AddHhSatm < ActiveRecord::Migration
  def self.up
    # add_column :claims_data, :smok_smoking_history, :string, :limit => 18
    # add_column :claims_data, :smready_smoking_readiness_quit, :string, :limit => 32
    # add_column :claims_data, :smref_smoking_action_referral, :string, :limit => 32
    # add_column :claims_data, :smpatrx_smoking_patch_rx, :string, :limit => 18
    # add_column :claims_data, :smgumrx_smoking_gum_rx, :string, :limit => 18
    # add_column :claims_data, :smothrx_smoking_other_rx, :string, :limit => 28
    
    if ( Settings.database =~ /hhcm|phocm/ )
      puts "Adding Smoking ATM Harbour Health"
      

      # Diabetes Self Management Education for Harbour Health
      Programme.create_with_id 22, :code => 'SATM', :description => 'Smoking ATM', :internal_only => true
      
      FeeSchedule.create_with_id 2200, :programme_id => 22, :code => 'SASS', :description => 'Assessment', :fee => 0.00, :gl_account_no => '0000-00', :is_the_default => true
      
      ProgrammeElement.populate(22, [ 
                    { :position => 0,  :column_name => 'smok_smoking_history'},
                    { :position => 1,  :column_name => 'smready_smoking_readiness_quit'},
                    
                    { :position => 4,  :column_name => 'smref_smoking_action_referral'},
                    
                    { :position => 8,  :column_name => 'smpatrx_smoking_patch_rx'},
                    { :position => 9,  :column_name => 'smgumrx_smoking_gum_rx'},
                    { :position => 10,  :column_name => 'smothrx_smoking_other_rx'}
                    ])      
    end
  end

  def self.down
  end
end
