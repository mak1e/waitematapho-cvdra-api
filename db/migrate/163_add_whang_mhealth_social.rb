class AddWhangMhealthSocial < ActiveRecord::Migration
  # MS: 2012-05 Missing a new field. :mhswk_mhealth_contract_social_worker in whanganui's  
  def self.up
    add_column :claims_data, :mhswk_mhealth_contract_social_worker, :boolean
    
    if ( Programme.exists?(12) )
      p=ProgrammeElement.new( { :programme_id => 12,  :position => 10,  :column_name => 'mhswk_mhealth_contract_social_worker' } )
      p.save!
    end
  end
    if ( Programme.exists?(12) )
      p=ProgrammeElement.new( { :programme_id => 12,  :position => 10,  :column_name => 'mhswk_mhealth_contract_social_worker' } )
      p.save!
    end

  def self.down
    remove_column :claims_data, :mhswk_mhealth_contract_social_worker
  end
end
