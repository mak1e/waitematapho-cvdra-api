class AddWhangSmokingOutcome < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :smoc_smoking_outcome, :string, :limit => 32
    puts "Adding smoc_smoking_outcome"
    # SSBAOC=smoc_smoking_outcome,Outcome,s

    ClaimsData.reset_column_information
    DataField.populate_table
    
    if ( Programme.exists?(Programme::SCSWR) )
       puts "Update Smoking Cessation View"
       pe=ProgrammeElement.new({ :programme_id => 20, 
                                 :position => 13,  :column_name => 'smoc_smoking_outcome'} )
       pe.save!
    end
  end

  def self.down
    remove_column :claims_data, :smoc_smoking_outcome
  end
end
