class AddDateServiceX < ActiveRecord::Migration
  def self.up
    # Whanganui records multiple dates of service 
    # A bit messy - But its part of the reporting requirements
    # Also seems a bit ott with 12 dates !!!! 
    add_column :claims_data, :ds01_date_service_01, :date
    add_column :claims_data, :ds02_date_service_02, :date
    add_column :claims_data, :ds03_date_service_03, :date
    add_column :claims_data, :ds04_date_service_04, :date
    add_column :claims_data, :ds05_date_service_05, :date
    add_column :claims_data, :ds06_date_service_06, :date
    add_column :claims_data, :ds07_date_service_07, :date
    add_column :claims_data, :ds08_date_service_08, :date
    add_column :claims_data, :ds09_date_service_09, :date
    add_column :claims_data, :ds10_date_service_10, :date
    add_column :claims_data, :ds11_date_service_11, :date
    ClaimsData.reset_column_information
    DataField.populate_table
    
    if ( Settings.database =~ /wrpho|phocm/ )
      puts "Whanganui PHO - Adding Date of Sevice 1..11"
      
      # Add each programme 
      wrpho_programme_list=[42,43,44,45,46]
      wrpho_programme_list.each do |programme_id|
         date_service_list = [
           { :position => 4,  :column_name => 'ds01_date_service_01'},
           { :position => 5,  :column_name => 'ds02_date_service_02'},
           { :position => 6,  :column_name => 'ds03_date_service_03'},
           
           { :position => 8,  :column_name => 'ds04_date_service_04'},
           { :position => 9,  :column_name => 'ds05_date_service_05'},
           { :position => 10, :column_name => 'ds06_date_service_06'},
           
           { :position => 12, :column_name => 'ds07_date_service_07'},
           { :position => 13, :column_name => 'ds08_date_service_08'},
           { :position => 14, :column_name => 'ds09_date_service_09'},
           
           { :position => 16, :column_name => 'ds10_date_service_10'},
           { :position => 17, :column_name => 'ds11_date_service_11'},
           ]
         date_service_list.each do |elem_hash|
           e=ProgrammeElement.new(elem_hash)
           e.programme_id = programme_id
           e.save!
         end
      end
    end 
  end

  def self.down
  end
end
