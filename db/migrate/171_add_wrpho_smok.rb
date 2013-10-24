class AddWrphoSmok < ActiveRecord::Migration
  def self.up
    
  if ( Settings.database =~ /wrpho|phocm_wrpho/ )
  
    add_column :claims_data, :smstatus, :string, :limit => 48
    add_column :claims_data, :attemptDate, :string, :limit => 48

    add_column :claims_data, :cpd, :string, :limit => 48
    add_column :claims_data, :cbPregnant, :string, :limit => 48
    add_column :claims_data, :briefAdvice, :string, :limit => 48
    add_column :claims_data, :csmeds, :string, :limit => 48
    add_column :claims_data, :nrt1, :string, :limit => 48
    add_column :claims_data, :nrt2, :string, :limit => 48
    add_column :claims_data, :nrt3, :string, :limit => 48
    add_column :claims_data, :nrt4, :string, :limit => 48
    add_column :claims_data, :nrt5, :string, :limit => 48
    add_column :claims_data, :nrt6, :string, :limit => 48
    
    add_column :claims_data, :csrf, :string, :limit => 48
    add_column :claims_data, :csbs, :string, :limit => 48
    add_column :claims_data, :csdec, :string, :limit => 48
    add_column :claims_data, :cbDiscretion, :string, :limit => 48
     
    ClaimsData.reset_column_information
    DataField.populate_table

    choices = [
      ['briefAdvice', 
         "Yes\r\nNo"],
      ['csmeds', 
         "true\r\nfalse"]]
         
    choices.each do |choice|
        df=DataField.find_by_column_name(choice[0]);
        raise ArgumentError, "Data field not found '#{choice[0]}'"  if !df
        df.choices = choice[1];
        df.save!
    end

      puts "WRPHO - Smoking Status and Cessation"
      
      Programme.create_with_id 51, :code => 'SMOK', :description => 'Smoking Status and Cessation'
      
      FeeSchedule.create_with_id 5101, :programme_id => 51, :code => 'SMOK', :description => 'Smoking Status and Cessation', :fee => 0.00, :gl_account_no => '0000-00',:is_the_default => true,
          :is_a_entry_service => 1, :is_a_exit_service => 1, :is_a_practice_service => 1,
          :is_a_declined_service => 0, :is_a_dnr_service => 0
          
      ProgrammeElement.populate(51, [
          { :position => 0,  :column_name => 'smstatus'},
          { :position => 1,  :column_name => 'attemptDate'},
          { :position => 2,  :column_name => 'cpd'},

          { :position => 4,  :column_name => 'cbPregnant'}, 
          { :position => 5,  :column_name => 'briefAdvice'}, 
          { :position => 6,  :column_name => 'csmeds'}, 

          { :position => 8,  :column_name => 'nrt1'}, 
          { :position => 9,  :column_name => 'nrt2'}, 
          { :position => 10,  :column_name => 'nrt3'}, 
          { :position => 11,  :column_name => 'nrt4'}, 
           
         { :position => 12,  :column_name => 'nrt5'}, 
         { :position => 13,  :column_name => 'nrt6'}, 
           
         { :position => 16,  :column_name => 'csrf'}, 
         { :position => 17,  :column_name => 'csbs'}, 
         { :position => 18,  :column_name => 'csdec'}, 
           
         { :position => 20,  :column_name => 'cbDiscretion'} 

        ]);
        
  end

  end

  def self.down
    
    if ( Settings.database =~ /wrpho|phocm_wrpho/ )

      remove_column :claims_data, :smstatus
      remove_column :claims_data, :attemptDate
      remove_column :claims_data, :cpd
      remove_column :claims_data, :cbPregnant
      remove_column :claims_data, :briefAdvice
      remove_column :claims_data, :csmeds
      remove_column :claims_data, :nrt1
      remove_column :claims_data, :nrt2
      remove_column :claims_data, :nrt3
      remove_column :claims_data, :nrt4
      remove_column :claims_data, :nrt5
      remove_column :claims_data, :nrt6
      remove_column :claims_data, :csrf
      remove_column :claims_data, :csbs
      remove_column :claims_data, :csdec
      remove_column :claims_data, :cbDiscretion
  
      Programme.delete_all( 'id = 51' )
      FeeSchedule.delete_all( 'programme_id = 51' )

    end
  end
end