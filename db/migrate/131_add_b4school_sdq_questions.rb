class AddB4schoolSdqQuestions < ActiveRecord::Migration
  
  
  def self.up
    puts "Adding b4school PEDS/SDQ"
    
    add_column :claims_data, :pedsqv_peds_question_values, :string, :limit => 20 # 10 Questions, csv, 0=No,1=Yes
    ## add_column :claims_data, :pedsc_peds_comments, :string, :limit => 255 # No column, place PEDS comments in Clinical Information:
    add_column :claims_data, :sdqqv_sdq_question_values, :string, :limit => 50 # 25 Questions, csv, 0=No concern, 1=Some Concern, 2=Concerning (but varies, some questions are in reverse!!!)
    
    ClaimsData.reset_column_information
    DataField.populate_table
    DataField.new( { :column_name => 'sdq_view', :label => 'Sdq Questions View', :data_type => 'html' }).save!
    DataField.new( { :column_name => 'peds_view', :label => 'Peds Questions View', :data_type => 'html' }).save!
    
    if (( Settings.database =~ /hbpho|zzzzphocm/ ) && ( Programme.exists?(6) ))
      # Add SDQ and PEDS for HBPHO
      puts "Adding SDQ/PEDS (hbpho)"
      
      data = [ { :programme_id => 6,
                 :elements => [
                  { :position => 100, :column_name => 'sdq_view'},
                  { :position => 104, :column_name => 'peds_view'}
  
                ]}
           ]
    
      data.each do |programme|
        programme[:elements].each do |elem|
          e=ProgrammeElement.new(elem)
          e.programme_id = programme[:programme_id]
          e.save!
        end
      end
    end
    

    if (( Settings.database =~ /hhcm|ctcpho|phocm/ ) && ( Programme.exists?(6) ))
     
      # Add SDQ and PEDS for HBPHO
      puts "Adding SDQ/PEDS (harbourh/c2coast)"
      
      # Change name of ECE field, 
      d=DataField.find_by_column_name('sdqtcec_sqd_t_ece')
      d.label = 'Name ECE Center'
      d.save!
      
      data = [ { :programme_id => 6,
                 :elements => [
                  { :position => 3, :column_name => 'nokph_nok_phone'},
                  { :position => 52, :column_name => 'sdqtcec_sqd_t_ece'},
                  { :position => 60, :column_name => 'sdq_view'},
                  { :position => 64, :column_name => 'peds_view'}
  
                ]}
           ]
    
      data.each do |programme|
        programme[:elements].each do |elem|
          e=ProgrammeElement.new(elem)
          e.programme_id = programme[:programme_id]
          e.save!
        end
      end
    end
    
    
  end

  def self.down
    ProgrammeElement.delete_all( "programme_id = 6 and column_name in ('sdq_view','peds_view','nokph_nok_phone','sdqtcec_sqd_t_ece') ")
    DataField.delete_all( "column_name in ('sdq_view','peds_view') ")
    remove_column :claims_data, :pedsqv_peds_question_values
    remove_column :claims_data, :sdqqv_sdq_question_values
  end
end
