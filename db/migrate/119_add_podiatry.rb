class AddPodiatry < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :rfiskc_foot_risk_category, :string, :limit => 26
    add_column :claims_data, :podref_podiatary_referral, :string, :limit => 26
    add_column :claims_data, :podref_podiatary_referral2, :string, :limit => 26

    ClaimsData.reset_column_information
    DataField.populate_table
    choices = [
        ['rfiskc_foot_risk_category', "0-Low Risk\r\n1-At Risk (LOPS,Deformity)\r\n2-At Risk (PAD+LOPS)\r\n3-High Risk\r\n4-Active Foot Complication"],
        ['podref_podiatary_referral',"Orthopaedic review\r\nVascular review\r\nSecondary (foot disease)\r\nSecondary (other)\r\nOrthotic services\r\nSmoking cessation\r\nMaori/PI Health Providers"],          
        ['podref_podiatary_referral2',"Orthopaedic review\r\nVascular review\r\nSecondary (foot disease)\r\nSecondary (other)\r\nOrthotic services\r\nSmoking cessation\r\nMaori/PI Health Providers"]]
    choices.each do |choice|
        df=DataField.find_by_column_name(choice[0]);
        raise ArgumentError, "Data field not found '#{choice[0]}'"  if !df
        df.choices = choice[1];
        df.save!
    end
    if ( Settings.database =~ /hhcm|phocm/ )
      puts "Adding Community Based Podiatry - Harbour Health"
      

      # Diabetes Self Management Education for Harbour Health
      Programme.create_with_id 23, :code => 'PODI', :description => 'Community Based Podiatry'
      
      FeeSchedule.create_with_id 2300, :programme_id => 23, :code => 'PODRF', :description => 'Referral', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 0, :is_a_practice_service => 0,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 2301, :programme_id => 23, :code => 'PODFA', :description => 'First assessment', :fee => 45.00, :gl_account_no => '0000-00', 
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 0,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 2302, :programme_id => 23, :code => 'PODFU', :description => 'Follow up visit', :fee => 45.00, :gl_account_no => '0000-00',
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 0,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 2303, :programme_id => 23, :code => 'PODDC', :description => 'Final visit/Discharge', :fee => 45.00, :gl_account_no => '0000-00',
          :is_a_entry_service => 0, :is_a_exit_service => 1, :is_a_practice_service => 0,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 2304, :programme_id => 23, :code => 'PODSV', :description => 'Single visit/Discharge', :fee => 45.00, :gl_account_no => '0000-00',
          :is_a_entry_service => 0, :is_a_exit_service => 1, :is_a_practice_service => 0,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
      FeeSchedule.create_with_id 2308, :programme_id => 23, :code => 'PODNA', :description => 'DNA', :fee => 45.00, :gl_account_no => '0000-00',
          :is_a_entry_service => 0, :is_a_exit_service => 0, :is_a_practice_service => 0,
          :is_a_declined_service => 0, :is_a_dnr_service => 1
      FeeSchedule.create_with_id 2309, :programme_id => 23, :code => 'PODEC', :description => 'Declined', :fee => 0.00, :gl_account_no => '0000-00',
          :is_a_entry_service => 0, :is_a_exit_service => 1, :is_a_practice_service => 0,
          :is_a_declined_service => 0, :is_a_dnr_service => 1
      
      ProgrammeElement.populate(23, [ 
                    { :position => 0,  :column_name => 'rfiskc_foot_risk_category'},# Ist assessment only
                    
                    { :position => 4,  :column_name => 'podref_podiatary_referral'},
                    { :position => 5,  :column_name => 'podref_podiatary_referral2'} ]);
    end    
  end

  def self.down
    Programme.delete_all( 'id = 23' )
    FeeSchedule.delete_all( 'programme_id = 23' )
    ProgrammeElement.delete_all( 'programme_id = 23' )

    remove_column :claims_data, :rfiskc_foot_risk_category
    remove_column :claims_data, :podref_podiatary_referral
    remove_column :claims_data, :podref_podiatary_referral2

  end
end
