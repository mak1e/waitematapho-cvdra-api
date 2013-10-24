class ChangeDiabEthBreakdown < ActiveRecord::Migration
  def self.up
    if ( Settings.database =~ /hhcm|phocm/ )
      puts "Change Databetes data-set ethnicity category - new Waitemata PHO contract"
      # Ethnicities for diabetes are now same as cvdr. but different order !!!
     
      Ethnicity.update_all( "ethnicity_diab = 'Other', order_by_diab = 6'" );
      
      Ethnicity.update_all( "ethnicity_diab = 'Maori', order_by_diab = 1", "id >= 20 and id <= 29" );
      Ethnicity.update_all( "ethnicity_diab = 'Pacific', order_by_diab = 2'", "id >= 30 and id <= 39" );
      Ethnicity.update_all( "ethnicity_diab = 'Asian', order_by_diab = 4", "id >= 40 and id <= 49" );
      Ethnicity.update_all( "ethnicity_diab = 'Indian', order_by_diab = 3'", "id = 43" ); # Do last as is sub-domain of Asian
      Ethnicity.update_all( "ethnicity_diab = 'NZ European', order_by_diab = 5'", "id >= 10 and id <= 19" );
      
    end
  end

  def self.down
  end
end
