class CreateDhbs < ActiveRecord::Migration
  def self.up
    create_table :dhbs, { :id => false  } do |t|
      t.string :id, :limit => 3, :null => false
      t.string :name, :limit => 18, :null => false
      t.integer :position, :null => false      
      t.timestamps
    end
    
    execute "alter table dhbs add primary key (id)"

    Dhb.create_with_id 'NLD', :name => 'Northland', :position => 1
    Dhb.create_with_id 'NWA', :name => 'Waitemata', :position => 2
    Dhb.create_with_id 'CAK', :name => 'Auckland', :position => 3
    Dhb.create_with_id 'SAK', :name => 'Counties Manukau', :position => 4
    Dhb.create_with_id 'WKO', :name => 'Waikato', :position => 5
    Dhb.create_with_id 'LKS', :name => 'Lakes', :position => 6
    Dhb.create_with_id 'BOP', :name => 'Bay of Plenty', :position => 7
    Dhb.create_with_id 'TRW', :name => 'Tairawhiti', :position => 8
    Dhb.create_with_id 'TKI', :name => 'Taranaki', :position => 9
    Dhb.create_with_id 'HWB', :name => 'Hawkes Bay', :position => 10
    Dhb.create_with_id 'WNI', :name => 'Whanganui', :position => 11
    Dhb.create_with_id 'MWU', :name => 'MidCentral', :position => 12
    Dhb.create_with_id 'HUT', :name => 'Hutt', :position => 13
    Dhb.create_with_id 'CAP', :name => 'Capital and Coast', :position => 14
    Dhb.create_with_id 'WRP', :name => 'Wairarapa', :position => 15
    Dhb.create_with_id 'NLM', :name => 'Nelson Marlborough', :position => 16
    Dhb.create_with_id 'WCO', :name => 'West Coast', :position => 17
    Dhb.create_with_id 'CTY', :name => 'Canterbury', :position => 18
    Dhb.create_with_id 'SCY', :name => 'South Canterbury', :position => 19
    Dhb.create_with_id 'OTA', :name => 'Otago', :position => 20
    Dhb.create_with_id 'SLD', :name => 'Southland', :position => 21    
    
  end

  def self.down
    drop_table :dhbs
  end
end
