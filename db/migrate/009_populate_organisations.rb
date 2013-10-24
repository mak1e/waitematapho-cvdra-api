class PopulateOrganisations < ActiveRecord::Migration
  def self.up
    Organisation.create_with_id 30, :name => 'Silverdale Medical Centre',     :residential_street => '4 Silverdale Street',  :residential_suburb => 'Silverdale', :residential_city => 'Hibiscus Coast', :postal_street => '4 Silverdale Street', :postal_suburb => 'Silverdale', :postal_city => 'Hibiscus Coast', :postal_post_code => '', :phone => '427 9997', :fax => '427 8080', :hlink => 'silvermc', :pho_id => 201
    Organisation.create_with_id 36, :name => 'Torbay Medical Centre', :residential_street => '1042 Beach Road', :residential_suburb => 'Torbay', :residential_city => 'North Shore', :postal_street => '1042 Beach Road', :postal_suburb => 'Torbay', :postal_city => 'North Shore', :postal_post_code => '', :phone => '473 0348', :fax => '473 0557', :hlink => 'torbay', :pho_id => 201
    Organisation.create_with_id 17, :name => 'Highbury Medical Centre', :residential_street => '121 Birkenhead Avenue', :residential_suburb => 'Birkenhead', :residential_city => 'North Shore City', :postal_street => '121 Birkenhead Avenue', :postal_suburb => 'Birkenhead', :postal_city => 'North Shore City', :postal_post_code => '', :phone => '419 2180', :fax => '419 2182', :hlink => 'drwestra', :pho_id => 201
    Organisation.create_with_id 20, :name => 'Kawau Bay Health', :residential_street => 'Alnwick Street', :residential_suburb => 'Warkworth', :residential_city => 'Rodney', :postal_street => 'Alnwick Street', :postal_suburb => 'Warkworth', :postal_city => 'Rodney', :postal_post_code => '', :phone => '425 8549', :fax => '425 9232', :hlink => 'kawaubay', :pho_id => 201
    Organisation.create_with_id 23, :name => 'Kowhai Surgery', :residential_street => '10 Percy Street', :residential_suburb => 'Warkworth', :residential_city => 'Rodney', :postal_street => '10 Percy Street', :postal_suburb => 'Warkworth', :postal_city => 'Rodney', :postal_post_code => '', :phone => '425 7358', :fax => '425 9933', :hlink => 'kowhaisu', :pho_id => 201
    Organisation.create_with_id 27, :name => 'North Harbour Medical Centre', :residential_street => '4/326 Sunset Road', :residential_suburb => 'Mairangi Bay', :residential_city => 'North Shore City', :postal_street => '4/326 Sunset Road', :postal_suburb => 'Mairangi Bay', :postal_city => 'North Shore City', :postal_post_code => '', :phone => '479 2083', :fax => '478 2049', :hlink => 'nthhbrmc', :pho_id => 201
    Organisation.create_with_id 29, :name => 'Shakespeare Medical Centre', :residential_street => '57 Shakespeare Road', :residential_suburb => 'Milford', :residential_city => 'North Shore', :postal_street => '57 Shakespeare Road', :postal_suburb => 'Milford', :postal_city => 'North Shore', :postal_post_code => '', :phone => '486 3097', :fax => '489 7476', :hlink => 'shakspmc', :pho_id => 201
    Organisation.create_with_id 34, :name => 'Takapuna Healthcare', :residential_street => '25 Bracken Avenue', :residential_suburb => 'Takapuna', :residential_city => 'North Shore', :postal_street => '25 Bracken Avenue', :postal_suburb => 'Takapuna', :postal_city => 'North Shore', :postal_post_code => '', :phone => '489 5867', :fax => '488 9043', :hlink => 'takapuhc', :pho_id => 201
    Organisation.create_with_id 35, :name => 'Torbay Community Doctor', :residential_street => '8 Toroa Street', :residential_suburb => 'Torbay', :residential_city => 'North Shore', :postal_street => '8 Toroa Street', :postal_suburb => 'Torbay', :postal_city => 'North Shore', :postal_post_code => '', :phone => '473 9594', :fax => '473 6848', :hlink => 'pahunter', :pho_id => 201
    Organisation.create_with_id 33, :name => 'Sunset Family Doctors', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'sunsetfd', :pho_id => 201
    Organisation.create_with_id 6, :name => 'Browns Bay Medical Centre', :residential_street => '32 Anzac Street', :residential_suburb => 'Browns Bay', :residential_city => 'North Shore City', :postal_street => '32 Anzac Street', :postal_suburb => 'Browns Bay', :postal_city => 'North Shore City', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'brownsby', :pho_id => 201
    Organisation.create_with_id 22, :name => 'Kitchener Road Medical Centre', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'kitchner', :pho_id => 201
    Organisation.create_with_id 25, :name => 'Dr. L Wong', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'wongtaka', :pho_id => 201
    Organisation.create_with_id 9, :name => 'Birkenhead Medical Center', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'birkenhe', :pho_id => 201
    Organisation.create_with_id 11, :name => 'Devonport Medical Center', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'devonmc', :pho_id => 201
    Organisation.create_with_id 12, :name => 'Fenwick Medical Center', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'fenwckmc', :pho_id => 201
    Organisation.create_with_id 13, :name => 'Family Medicine Birkenhead', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'famsptak', :pho_id => 201
    Organisation.create_with_id 15, :name => 'Glenfield Medical Center', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'glenmc', :pho_id => 201
    Organisation.create_with_id 19, :name => 'HealthZone', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'milenumc', :pho_id => 201
    Organisation.create_with_id 21, :name => 'Kowhai Clinic (Glenfield)', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'kowhai', :pho_id => 201
    Organisation.create_with_id 37, :name => 'Waiake Medical Centre', :residential_street => '1 Hebron Road', :residential_suburb => 'Waiake', :residential_city => 'North Shore', :postal_street => '1 Hebron Road', :postal_suburb => 'Waiake', :postal_city => 'North Shore', :postal_post_code => '', :phone => '477 7660', :fax => '479 2044', :hlink => 'waiamedi', :pho_id => 201
    Organisation.create_with_id 8, :name => 'Belmont Medical Center', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'belmonmc', :pho_id => 201
    Organisation.create_with_id 7, :name => 'Beachhaven Medical', :residential_street => '330 Rangitira Road', :residential_suburb => 'Beachhaven', :residential_city => 'North Shore', :postal_street => 'PO Box 66-003', :postal_suburb => 'Beachhaven', :postal_city => 'North Shore', :postal_post_code => '1330', :phone => '483 6422', :fax => '483 6422', :hlink => 'drjarcus', :pho_id => 201
    Organisation.create_with_id 1, :name => 'Albany Basin Accident & Medical', :residential_street => '', :residential_suburb => 'Albany', :residential_city => 'North Shore', :postal_street => '', :postal_suburb => 'Albany', :postal_city => 'North Shore', :postal_post_code => '', :phone => '443 7777', :fax => '444 1101', :hlink => 'albanyam', :pho_id => 201
    Organisation.create_with_id 5, :name => 'Browns Bay Family Doctors', :residential_street => '65 Clyde Road', :residential_suburb => 'Browns Bay', :residential_city => 'North Shore', :postal_street => '65 Clyde Road', :postal_suburb => 'Browns Bay', :postal_city => 'North Shore', :postal_post_code => '', :phone => '479 4834', :fax => '478 5738', :hlink => 'bbfd', :pho_id => 201
    Organisation.create_with_id 14, :name => 'Glenfield Doctors on Chartwell', :residential_street => '52 Chartwell Avenue', :residential_suburb => 'Glenfield', :residential_city => 'North Shore', :postal_street => '52 Chartwell Avenue', :postal_suburb => 'Glenfield', :postal_city => 'North Shore', :postal_post_code => '1330', :phone => '441 2352', :fax => '441 6176', :hlink => 'drjwilcx', :pho_id => 201
    Organisation.create_with_id 2, :name => 'Albany Family Medical Centre', :residential_street => '368 Albany Highway', :residential_suburb => 'Albany', :residential_city => 'North Shore City', :postal_street => '368 Albany Highway', :postal_suburb => 'Albany', :postal_city => 'North Shore City', :postal_post_code => '', :phone => '415 8959', :fax => '415 8139', :hlink => 'albanyfm', :pho_id => 201
    Organisation.create_with_id 4, :name => 'Archers Medical Centre', :residential_street => '130 Archers Road', :residential_suburb => 'Glenfield', :residential_city => 'North Shore City', :postal_street => '130 Archers Road', :postal_suburb => 'Glenfield', :postal_city => 'North Shore City', :postal_post_code => '', :phone => '444 9324', :fax => '444 3160', :hlink => 'glenmall', :pho_id => 201
    Organisation.create_with_id 31, :name => 'Sunnynook Medical Centre', :residential_street => '119 Sunnynook Road', :residential_suburb => 'Sunnynook', :residential_city => 'North Shore', :postal_street => '119 Sunnynook Road', :postal_suburb => 'Sunnynook', :postal_city => 'North Shore', :postal_post_code => '1330', :phone => '410 5331', :fax => '410 8319', :hlink => 'sunnymed', :pho_id => 201
    Organisation.create_with_id 16, :name => 'Hauraki Medical Centre', :residential_street => '308 Lake Road', :residential_suburb => 'Takapuna', :residential_city => 'North Shore', :postal_street => '308 Lake Road', :postal_suburb => 'Takapuna', :postal_city => 'North Shore', :postal_post_code => '', :phone => '489 5059', :fax => '486 4937', :hlink => 'hauramed', :pho_id => 201
    Organisation.create_with_id 3, :name => 'Medical Centre at Apollo', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'primarym', :pho_id => 201
    Organisation.create_with_id 24, :name => 'Dr. J and M Lockwood', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'emlockwd', :pho_id => 201
    Organisation.create_with_id 18, :name => 'Dr Serene Hu', :residential_street => '185 Northcote Road', :residential_suburb => 'Northcote', :residential_city => 'North Shore', :postal_street => '185 Northcote Road', :postal_suburb => 'Northcote', :postal_city => 'North Shore', :postal_post_code => '', :phone => '480 9309', :fax => '480 9309', :hlink => 'serenahu', :pho_id => 201
    Organisation.create_with_id 28, :name => 'Onewa Road Doctors Surgery', :residential_street => '225 Onewa Road', :residential_suburb => 'Birkenhead', :residential_city => 'North Shore', :postal_street => '225 Onewa Road', :postal_suburb => 'Birkenhead', :postal_city => 'North Shore', :postal_post_code => '', :phone => '418 3832', :fax => '419 0918', :hlink => 'drgrjohn', :pho_id => 201
    Organisation.create_with_id 10, :name => 'Byron Medical', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'byronchm', :pho_id => 201
    Organisation.create_with_id 26, :name => 'Massey Uni', :residential_street => '', :residential_suburb => '', :residential_city => '', :postal_street => '', :postal_suburb => '', :postal_city => '', :postal_post_code => '', :phone => '', :fax => '', :hlink => 'masseyak', :pho_id => 201
    
    # Add in population
    
	o=Organisation.find(1); o.est_no_patients = 4127; o.save!
	o=Organisation.find(2); o.est_no_patients = 7762; o.save!
	o=Organisation.find(3); o.est_no_patients = 14338; o.save!
	o=Organisation.find(4); o.est_no_patients = 2258; o.save!
	o=Organisation.find(5); o.est_no_patients = 4690; o.save!
	o=Organisation.find(6); o.est_no_patients = 7506; o.save!
	o=Organisation.find(7); o.est_no_patients = 2190; o.save!
	o=Organisation.find(8); o.est_no_patients = 2319; o.save!
	o=Organisation.find(9); o.est_no_patients = 7219; o.save!
	o=Organisation.find(10); o.est_no_patients = 2150; o.save!
	o=Organisation.find(11); o.est_no_patients = 2663; o.save!
	o=Organisation.find(12); o.est_no_patients = 2398; o.save!
	o=Organisation.find(13); o.est_no_patients = 3086; o.save!
	o=Organisation.find(14); o.est_no_patients = 2940; o.save!
	o=Organisation.find(15); o.est_no_patients = 6405; o.save!
	o=Organisation.find(16); o.est_no_patients = 7598; o.save!
	o=Organisation.find(17); o.est_no_patients = 1262; o.save!
	o=Organisation.find(18); o.est_no_patients = 3751; o.save!
	o=Organisation.find(19); o.est_no_patients = 1529; o.save!
	o=Organisation.find(20); o.est_no_patients = 8011; o.save!
	o=Organisation.find(21); o.est_no_patients = 5113; o.save!
	o=Organisation.find(22); o.est_no_patients = 4572; o.save!
	o=Organisation.find(23); o.est_no_patients = 3447; o.save!
	o=Organisation.find(24); o.est_no_patients = 2587; o.save!
	o=Organisation.find(25); o.est_no_patients = 677; o.save!
	o=Organisation.find(26); o.est_no_patients = 903; o.save!
	o=Organisation.find(27); o.est_no_patients = 3462; o.save!
	o=Organisation.find(28); o.est_no_patients = 1613; o.save!
	o=Organisation.find(29); o.est_no_patients = 4039; o.save!
	o=Organisation.find(30); o.est_no_patients = 3372; o.save!
	o=Organisation.find(31); o.est_no_patients = 3293; o.save!
	o=Organisation.find(33); o.est_no_patients = 7080; o.save!
	o=Organisation.find(34); o.est_no_patients = 2048; o.save!
	o=Organisation.find(35); o.est_no_patients = 1452; o.save!
	o=Organisation.find(36); o.est_no_patients = 7612; o.save!
	o=Organisation.find(37); o.est_no_patients = 2966; o.save!
    
    
  end
  

  def self.down
  end
end
