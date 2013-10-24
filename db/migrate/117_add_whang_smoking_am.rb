class AddWhangSmokingAm < ActiveRecord::Migration
  def self.up
    if ( Programme.exists?(Programme::SCSWR) )
       puts "Adding Smoking Whanganui A+M Services"
       
       FeeSchedule.create_with_id 2015, :programme_id => 20, :code => 'SCWAM', :description => 'A+M Service', :fee => 10.00, :gl_account_no => '0000-00'
       
       pe=ProgrammeElement.new( { :programme_id => 20, 
                                 :position => 2,  :column_name => 'preg_pregnant' } )
       pe.save!
       
       
    end
    
    puts "Adding Benign Lesion"
    
    change_column :claims_data, :slty_skin_lesion_type, :string, :limit => 35
    add_column :claims_data, :slbt_skin_lesion_benign_type, :string, :limit => 35
    ClaimsData.reset_column_information
    DataField.populate_table
    
    if ( Programme.exists?(9) ) 
      puts "Updating Skin Lesion Whanganui Columns"
       
      ProgrammeElement.populate(9, [ 
                  { :position => 0,  :column_name => 'smok_smoking_history'},
                  { :position => 4,  :column_name => 'slty_skin_lesion_type'},
                  { :position => 5,  :column_name => 'slbt_skin_lesion_benign_type'},
                  { :position => 8,  :column_name => 'sllo_skin_lesion_location'},
                  { :position => 9,  :column_name => 'slex_skin_lesion_excision'}] )
      
    end

    
    # Fix up Diabetes Choices "Diabetes Status Unknown" is too long change tyo "Status Unknown"
    df=DataField.find_by_column_name('diab_type_of_diabetes');
    df.choices = "No diabetes\r\nType 1\r\nType 2\r\nType unknown\r\nGestational\r\nOther known type\r\nIGT / IFG\r\nStatus unknown";
    df.save!
    
  end

  def self.down
    remove_column :claims_data, :slbt_skin_lesion_benign_type
    FeeSchedule.delete_all( 'id = 2005' );
    ProgrammeElement.delete_all( 'programme_id = 20 and position = 2' );
    ProgrammeElement.delete_all( 'programme_id = 9 and position = 5' );
  end
end
