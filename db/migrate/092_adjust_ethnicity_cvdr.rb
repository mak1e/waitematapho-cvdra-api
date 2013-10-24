class AdjustEthnicityCvdr < ActiveRecord::Migration
  def self.up
    Ethnicity.update_all( "ethnicity_cvdr = 'Other', order_by_cvdr = 5'" );
    Ethnicity.update_all( "ethnicity_cvdr = 'Maori', order_by_cvdr = 1", "id >= 20 and id <= 29" );
    Ethnicity.update_all( "ethnicity_cvdr = 'Pacific', order_by_cvdr = 2'", "id >= 30 and id <= 39" );
    Ethnicity.update_all( "ethnicity_cvdr = 'Indian', order_by_cvdr = 3", "id = 43" );
    Patient.update_all( "ethnicity_id = null", "ethnicity_id is not null and ethnicity_id not in ( select id from ethnicities )" );
  end

  def self.down
  end
end
