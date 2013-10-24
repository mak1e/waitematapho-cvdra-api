class AddOrganisationFields < ActiveRecord::Migration
  def self.up
    add_column :organisations, :cbf_ident, :string, :limit => 8
    add_column :organisations, :contact_name, :string, :limit => 18
    
    o=Organisation.find(1); o.cbf_ident = 'NHALB'; o.save!;
    o=Organisation.find(2); o.cbf_ident = 'NHALF'; o.save!;
    o=Organisation.find(4); o.cbf_ident = 'NHARC'; o.save!;
    o=Organisation.find(7); o.cbf_ident = 'NHBHM'; o.save!;
    o=Organisation.find(8); o.cbf_ident = 'NHBLM'; o.save!;
    o=Organisation.find(9); o.cbf_ident = 'NHBRM'; o.save!;
    o=Organisation.find(5); o.cbf_ident = 'NHBBF'; o.save!;
    o=Organisation.find(6); o.cbf_ident = 'NHBBM'; o.save!;
    o=Organisation.find(10); o.cbf_ident = 'NHBYR'; o.save!;
    o=Organisation.find(11); o.cbf_ident = 'NHDMC'; o.save!;
    o=Organisation.find(24); o.cbf_ident = 'NHLWD'; o.save!;
    o=Organisation.find(25); o.cbf_ident = 'NHLWG'; o.save!;
    o=Organisation.find(13); o.cbf_ident = 'NHFSM'; o.save!;
    o=Organisation.find(12); o.cbf_ident = 'NHFMC'; o.save!;
    o=Organisation.find(14); o.cbf_ident = 'NHGDC'; o.save!;
    o=Organisation.find(15); o.cbf_ident = 'NHGMC'; o.save!;
    o=Organisation.find(16); o.cbf_ident = 'NHHAU'; o.save!;
    o=Organisation.find(19); o.cbf_ident = 'NHHZN'; o.save!;
    o=Organisation.find(17); o.cbf_ident = 'NHHIG'; o.save!;
    o=Organisation.find(20); o.cbf_ident = 'NHKAW'; o.save!;
    o=Organisation.find(22); o.cbf_ident = 'NHKIT'; o.save!;
    o=Organisation.find(21); o.cbf_ident = 'NHKCG'; o.save!;
    o=Organisation.find(23); o.cbf_ident = 'NHKOW'; o.save!;
    o=Organisation.find(26); o.cbf_ident = 'NHMAU'; o.save!;
    o=Organisation.find(3); o.cbf_ident = 'NHAPO'; o.save!;
    o=Organisation.find(27); o.cbf_ident = 'NHNHM'; o.save!;
    o=Organisation.find(43); o.cbf_ident = 'NHHUS'; o.save!;
    o=Organisation.find(28); o.cbf_ident = 'NHONE'; o.save!;
    o=Organisation.find(29); o.cbf_ident = 'NHSHA'; o.save!;
    o=Organisation.find(30); o.cbf_ident = 'NHSIL'; o.save!;
    o=Organisation.find(31); o.cbf_ident = 'NHSMC'; o.save!;
    o=Organisation.find(33); o.cbf_ident = 'NHSUN'; o.save!;
    o=Organisation.find(34); o.cbf_ident = 'NHTAK'; o.save!;
    o=Organisation.find(35); o.cbf_ident = 'NHTOC'; o.save!;
    o=Organisation.find(36); o.cbf_ident = 'NHTOR'; o.save!;
    o=Organisation.find(37); o.cbf_ident = 'NHWAI'; o.save!;
  
  end


  def self.down
  end
end
