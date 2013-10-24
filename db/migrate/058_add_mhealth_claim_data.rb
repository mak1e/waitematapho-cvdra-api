class AddMhealthClaimData < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :mhdx_mhealth_diagnosis , :string, :limit => 18
    add_column :claims_data, :mhdx2_mhealth_diagnosis_2 , :string, :limit => 18
    add_column :claims_data, :mhdx3_mhealth_diagnosis_3 , :string, :limit => 18
    add_column :claims_data, :como_co_morbidities , :string, :limit => 36
    add_column :claims_data, :qolr_quality_of_life_rating , :string, :limit => 5
    add_column :claims_data, :copa_co_payment_amount, :decimal, :precision => 8, :scale => 2
    
    DataField.populate_table
     
  end

  def self.down
    remove_column :claims_data, :mhdx_mhealth_diagnosis
    remove_column :claims_data, :mhdx2_mhealth_diagnosis_2
    remove_column :claims_data, :mhdx3_mhealth_diagnosis_3
    remove_column :claims_data, :como_co_morbidities
    remove_column :claims_data, :qolr_quality_of_life_rating
    remove_column :claims_data, :copa_co_payment_amount

    DataField.populate_table
    
  end
end
