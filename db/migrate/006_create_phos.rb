class CreatePhos < ActiveRecord::Migration
  def self.up
    create_table :phos do |t|
      t.string :name, :limit => 40, :null => false
      t.string :dhb_id, :limit => 3, :null => false
      t.integer :est_no_patients
      t.boolean :deleted, :null => false, :default => 0

      t.timestamps
    end
    
    Pho.create_with_id '101', :name => 'Manaia Health PHO', :dhb_id => 'NLD', :est_no_patients => 77785
    Pho.create_with_id '102', :name => 'Te Tai Tokerau PHO', :dhb_id => 'NLD', :est_no_patients => 42664
    Pho.create_with_id '103', :name => 'Kaipara Care', :dhb_id => 'NLD', :est_no_patients => 11630
    Pho.create_with_id '104', :name => 'Tihewa Mauriora', :dhb_id => 'NLD', :est_no_patients => 8598
    Pho.create_with_id '105', :name => 'Hauora Hokianga Integrated PHO', :dhb_id => 'NLD', :est_no_patients => 6454
    Pho.create_with_id '106', :name => 'Whangaroa PHO', :dhb_id => 'NLD', :est_no_patients => 3133
    Pho.create_with_id '201', :name => 'Harbour PHO', :dhb_id => 'NWA', :est_no_patients => 149243
    Pho.create_with_id '202', :name => 'HealthWest', :dhb_id => 'NWA', :est_no_patients => 137288
    Pho.create_with_id '203', :name => 'Procare Network North', :dhb_id => 'NWA', :est_no_patients => 96112
    Pho.create_with_id '204', :name => 'Waiora Healthcare', :dhb_id => 'NWA', :est_no_patients => 18806
    Pho.create_with_id '205', :name => 'Coast to Coast PHO', :dhb_id => 'NWA', :est_no_patients => 12957
    Pho.create_with_id '206', :name => 'Te Puna PHO', :dhb_id => 'NWA', :est_no_patients => 10623
    Pho.create_with_id '301', :name => 'Procare Network Auckland', :dhb_id => 'CAK', :est_no_patients => 307019
    Pho.create_with_id '302', :name => 'Auckland PHO', :dhb_id => 'CAK', :est_no_patients => 36511
    Pho.create_with_id '303', :name => 'Tamaki Healthcare', :dhb_id => 'CAK', :est_no_patients => 44886
    Pho.create_with_id '304', :name => 'AuckPAC Health Board', :dhb_id => 'CAK', :est_no_patients => 38790
    Pho.create_with_id '305', :name => 'Tikapa Moana PHO', :dhb_id => 'CAK', :est_no_patients => 6248
    Pho.create_with_id '306', :name => 'Tongan Health Society', :dhb_id => 'CAK', :est_no_patients => 5164
    Pho.create_with_id '401', :name => 'Procare Network Manukau', :dhb_id => 'SAK', :est_no_patients => 244203
    Pho.create_with_id '402', :name => 'East Health', :dhb_id => 'SAK', :est_no_patients => 75608
    Pho.create_with_id '403', :name => 'Total Healthcare Otara', :dhb_id => 'SAK', :est_no_patients => 76692
    Pho.create_with_id '404', :name => 'Te Kupenga O Hoturoa', :dhb_id => 'SAK', :est_no_patients => 33092
    Pho.create_with_id '405', :name => 'Mangere Community Health', :dhb_id => 'SAK', :est_no_patients => 10788
    Pho.create_with_id '406', :name => 'TaPasefika Health', :dhb_id => 'SAK', :est_no_patients => 19453
    Pho.create_with_id '407', :name => 'Peoples Healthcare', :dhb_id => 'SAK', :est_no_patients => 5575
    Pho.create_with_id '501', :name => 'Pinnacle (Waikato)', :dhb_id => 'WKO', :est_no_patients => 294325
    Pho.create_with_id '502', :name => 'The Maori PHO Coalition', :dhb_id => 'WKO', :est_no_patients => 12042
    Pho.create_with_id '503', :name => 'North Waikato PHO', :dhb_id => 'WKO', :est_no_patients => 8531
    Pho.create_with_id '504', :name => 'Hauraki PHO', :dhb_id => 'WKO', :est_no_patients => 7320
    Pho.create_with_id '601', :name => 'Rotorua General Practice Group', :dhb_id => 'LKS', :est_no_patients => 71671
    Pho.create_with_id '602', :name => 'Lake Taupo PHO', :dhb_id => 'LKS', :est_no_patients => 34433
    Pho.create_with_id '701', :name => 'Western Bay of Plenty PHO', :dhb_id => 'BOP', :est_no_patients => 128123
    Pho.create_with_id '702', :name => 'Eastern Bay of Plenty PHO', :dhb_id => 'BOP', :est_no_patients => 30793
    Pho.create_with_id '703', :name => 'Nga Mataapuna Oranga', :dhb_id => 'BOP', :est_no_patients => 13364
    Pho.create_with_id '704', :name => 'Te Ao Hou PHO', :dhb_id => 'BOP', :est_no_patients => 7716
    Pho.create_with_id '705', :name => 'Kawerau Interim PHO', :dhb_id => 'BOP', :est_no_patients => 7292
    Pho.create_with_id '801', :name => 'Turanganui PHO', :dhb_id => 'TRW', :est_no_patients => 32387
    Pho.create_with_id '802', :name => 'Ngati Porou Hauora', :dhb_id => 'TRW', :est_no_patients => 12971
    Pho.create_with_id '901', :name => 'Taranaki PHO', :dhb_id => 'TKI', :est_no_patients => 48095
    Pho.create_with_id '902', :name => 'Pinnacle (Taranaki)', :dhb_id => 'TKI', :est_no_patients => 46499
    Pho.create_with_id '903', :name => 'Te Tihi Hauora O Taranaki', :dhb_id => 'TKI', :est_no_patients => 5748
    Pho.create_with_id '1001', :name => 'Hawkes Bay PHO', :dhb_id => 'HWB', :est_no_patients => 120690
    Pho.create_with_id '1002', :name => 'Tu Meke - First Choice PHO', :dhb_id => 'HWB', :est_no_patients => 12832
    Pho.create_with_id '1003', :name => 'Wairoa District Charitable Health', :dhb_id => 'HWB', :est_no_patients => 8335
    Pho.create_with_id '1101', :name => 'Whanganui Regional PHO', :dhb_id => 'WNI', :est_no_patients => 57704
    Pho.create_with_id '1102', :name => 'Taumata Hauora', :dhb_id => 'WNI', :est_no_patients => 5770
    Pho.create_with_id '1201', :name => 'Manawatu PHO', :dhb_id => 'MWU', :est_no_patients => 97059
    Pho.create_with_id '1202', :name => 'Horowhenua PHO', :dhb_id => 'MWU', :est_no_patients => 25098
    Pho.create_with_id '1203', :name => 'Tararua PHO', :dhb_id => 'MWU', :est_no_patients => 15256
    Pho.create_with_id '1204', :name => 'Otaki PHO', :dhb_id => 'MWU', :est_no_patients => 6156
    Pho.create_with_id '1301', :name => 'Valley PHO', :dhb_id => 'HUT', :est_no_patients => 62093
    Pho.create_with_id '1302', :name => 'MidValley Access PHO', :dhb_id => 'HUT', :est_no_patients => 20536
    Pho.create_with_id '1303', :name => 'Ropata Community PHO', :dhb_id => 'HUT', :est_no_patients => 17023
    Pho.create_with_id '1304', :name => 'FamilyCare PHO', :dhb_id => 'HUT', :est_no_patients => 15168
    Pho.create_with_id '1305', :name => 'Piki te Ora ki Te Awakairangi', :dhb_id => 'HUT', :est_no_patients => 12516
    Pho.create_with_id '1306', :name => 'Tamaiti Whangai PHO', :dhb_id => 'HUT', :est_no_patients => 4854
    Pho.create_with_id '1401', :name => 'Capital PHO', :dhb_id => 'CAP', :est_no_patients => 136645
    Pho.create_with_id '1402', :name => 'Tumai mo te Iwi Inc', :dhb_id => 'CAP', :est_no_patients => 45007
    Pho.create_with_id '1403', :name => 'Kapiti PHO', :dhb_id => 'CAP', :est_no_patients => 33436
    Pho.create_with_id '1404', :name => 'Porirua Health Plus', :dhb_id => 'CAP', :est_no_patients => 12981
    Pho.create_with_id '1405', :name => 'Karori PHO', :dhb_id => 'CAP', :est_no_patients => 12378
    Pho.create_with_id '1406', :name => 'South East & City PHO', :dhb_id => 'CAP', :est_no_patients => 9387
    Pho.create_with_id '1501', :name => 'Wairarapa Community PHO', :dhb_id => 'WRP', :est_no_patients => 37483
    Pho.create_with_id '1601', :name => 'Nelson-Tasman PHO', :dhb_id => 'NLM', :est_no_patients => 86570
    Pho.create_with_id '1602', :name => 'Marlborough PHO', :dhb_id => 'NLM', :est_no_patients => 38767
    Pho.create_with_id '1701', :name => 'West Coast PHO', :dhb_id => 'WCO', :est_no_patients => 28270
    Pho.create_with_id '1801', :name => 'Partnership Health Canterbury', :dhb_id => 'CTY', :est_no_patients => 341208
    Pho.create_with_id '1802', :name => 'Rural Canterbury PHO', :dhb_id => 'CTY', :est_no_patients => 61171
    Pho.create_with_id '1803', :name => 'Christchurch City PHO', :dhb_id => 'CTY', :est_no_patients => 25271
    Pho.create_with_id '1804', :name => 'Hurunui Kaikoura PHO', :dhb_id => 'CTY', :est_no_patients => 12638
    Pho.create_with_id '1805', :name => 'Canterbury Community PHO', :dhb_id => 'CTY', :est_no_patients => 5272
    Pho.create_with_id '1901', :name => 'South Canterbury PHO', :dhb_id => 'SCY', :est_no_patients => 54288
    Pho.create_with_id '2001', :name => 'Dunedin City PHO', :dhb_id => 'OTA', :est_no_patients => 77872
    Pho.create_with_id '2002', :name => 'Central Otago PHO', :dhb_id => 'OTA', :est_no_patients => 38916
    Pho.create_with_id '2003', :name => 'Otago Southern Region PHO', :dhb_id => 'OTA', :est_no_patients => 17446
    Pho.create_with_id '2004', :name => 'Mornington PHO', :dhb_id => 'OTA', :est_no_patients => 15431
    Pho.create_with_id '2005', :name => 'Taieri and Strath Taieri PHO', :dhb_id => 'OTA', :est_no_patients => 14074
    Pho.create_with_id '2101', :name => 'Waihopai PHO', :dhb_id => 'SLD', :est_no_patients => 58809
    Pho.create_with_id '2102', :name => 'Eastern and Northern South', :dhb_id => 'SLD', :est_no_patients => 17465
    Pho.create_with_id '2103', :name => 'Wakatipu PHO', :dhb_id => 'SLD', :est_no_patients => 14159
    Pho.create_with_id '2104', :name => 'Rural Southland PHO', :dhb_id => 'SLD', :est_no_patients => 14144
    
  end

  def self.down
    drop_table :phos
  end
end
