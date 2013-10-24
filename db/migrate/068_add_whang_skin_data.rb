class AddWhangSkinData < ActiveRecord::Migration
  def self.up
    # add_column :claims_data, :slcx_skin_lesion_complexity, :string, :limit => 18
    add_column :claims_data, :slty_skin_lesion_type, :string, :limit => 18
    add_column :claims_data, :sllo_skin_lesion_location, :string, :limit => 38
    add_column :claims_data, :slex_skin_lesion_excision, :string, :limit => 18
    ClaimsData.reset_column_information
    DataField.populate_table    
    
    choices = [
        # ['slcx_skin_lesion_complexity', "Simple\r\nComplex"],
        ['slty_skin_lesion_type', "Squamous Cell Carcinoma\r\nBasal Cell Carcinoma\r\nKerotoacanthoma\r\nDysplatic Mole\r\nMelanoma\r\nOther"],
        ['slex_skin_lesion_excision', "Complete\r\nIncomplete"]
        ]
        
     choices.each do |choice|
        df=DataField.find_by_column_name(choice[0]);
        raise ArgumentError, "Data field not found '#{choice[0]}'"  if !df
        df.choices = choice[1];
        df.save!
     end    

    Programme.create_with_id 9, :code => 'SL', :description => 'Skin Lesions'
    
    FeeSchedule.create_with_id 900, :programme_id => 9, :code => 'SLS', :description => 'Skin Lesion Simple', :fee => 156.53, :gl_account_no => '09-0000'
    FeeSchedule.create_with_id 901, :programme_id => 9, :code => 'SLC', :description => 'Skin Lesion Complex', :fee => 265.21, :gl_account_no => '09-0001'
    
    FeeSchedule.update_all('is_a_entry_service = 1');
    FeeSchedule.update_all('is_a_exit_service = 1');
    FeeSchedule.update_all('is_a_practice_service = 1');
    
    ProgrammeElement.populate(9, [ 
                  { :position => 0,  :column_name => 'smok_smoking_history'},
                  { :position => 4,  :column_name => 'slty_skin_lesion_type'},
                  { :position => 5,  :column_name => 'sllo_skin_lesion_location'},
                  { :position => 6,  :column_name => 'slex_skin_lesion_excision'}])
    
  end

  def self.down
    # remove_column :claims_data, :slcx_skin_lesion_complexity
    remove_column :claims_data, :slty_skin_lesion_type
    remove_column :claims_data, :sllo_skin_lesion_location
    remove_column :claims_data, :slex_skin_lesion_excision
    ClaimsData.reset_column_information
    DataField.populate_table    
    
    Programme.delete_all( 'id = 9')
    FeeSchedule.delete_all( 'programme_id = 9')
    ProgrammeElement.delete_all( 'programme_id = 9')        
  end
end
