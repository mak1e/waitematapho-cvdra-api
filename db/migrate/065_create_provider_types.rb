class CreateProviderTypes < ActiveRecord::Migration
  def self.up
    create_table :provider_types do |t|
      t.string :description, :limit => 18, :null => false
      t.integer :position, :null => false, :default => 0      
    end
    ProviderType.create_with_id  1, :description => 'Doctor'
    ProviderType.create_with_id  2, :description => 'Nurse'
    ProviderType.create_with_id  3, :description => 'Specalist'
    ProviderType.create_with_id  4, :description => 'Radiologist'
    ProviderType.create_with_id  5, :description => 'Laboratory'
    ProviderType.create_with_id  6, :description => 'Physiotherapist'
    ProviderType.create_with_id  7, :description => 'Psychologist'
    ProviderType.create_with_id  8, :description => 'Pharmacist'
    ProviderType.create_with_id  9, :description => 'Chiropractor'
    ProviderType.create_with_id  10, :description => 'Dentist'
    ProviderType.create_with_id  11, :description => 'Optometrist'
    ProviderType.create_with_id  12, :description => 'Midwife'
    ProviderType.update_all('position = id');
    
    add_column :providers, :provider_type_id , :integer

  end

  def self.down
    drop_table :provider_types
  end
end

