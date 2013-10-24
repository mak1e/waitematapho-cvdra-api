class AddEthnicityDiabCvdr < ActiveRecord::Migration
  def self.up
    # execute  "DROP FUNCTION dbo.ethnicity_cvdr"

    # Ethnicities for diabetes are different for diabetes
    add_column :ethnicities, :ethnicity_diab, :string, :limit => 35
    add_column :ethnicities, :order_by_diab, :integer
    
    # Ethnicities for cvdr are different for diabetes (include the high risk indian)
    add_column :ethnicities, :ethnicity_cvdr, :string, :limit => 35
    add_column :ethnicities, :order_by_cvdr, :integer
    
    # Ethnicities for diabetes are different for diabetes
    Ethnicity.update_all( "ethnicity_cvdr = 'Other', order_by_cvdr = 5'" );
    Ethnicity.update_all( "ethnicity_cvdr = 'European', order_by_cvdr = 1'", "id >= 10 and id <= 19" );
    Ethnicity.update_all( "ethnicity_cvdr = 'Maori', order_by_cvdr = 2", "id >= 20 and id <= 29" );
    Ethnicity.update_all( "ethnicity_cvdr = 'Pacific I', order_by_cvdr = 3'", "id >= 30 and id <= 39" );
    Ethnicity.update_all( "ethnicity_cvdr = 'Asian', order_by_cvdr = 4", "id >= 40 and id <= 49" );
    Ethnicity.update_all( "ethnicity_cvdr = 'Indian', order_by_cvdr = 5", "id = 43" );

    Ethnicity.update_all( "ethnicity_diab = 'Other', order_by_diab = 5'" );
    Ethnicity.update_all( "ethnicity_diab = 'NZ European', order_by_diab = 3'", "id >= 10 and id <= 19" );
    Ethnicity.update_all( "ethnicity_diab = 'Maori', order_by_diab = 1'", "id >= 20 and id <= 29" );
    Ethnicity.update_all( "ethnicity_diab = 'Pacific I', order_by_diab = 2'", "id >= 30 and id <= 39" );
  end

  def self.down
  end
end
