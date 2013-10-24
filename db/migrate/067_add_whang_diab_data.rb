class AddWhangDiabData < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :oorm_other_oral_medication, :string, :limit => 18
    add_column :claims_data, :omed_other_medication, :string, :limit => 18
    add_column :claims_data, :pctd_positive_changes_to_diet, :string, :limit => 18
    add_column :claims_data, :pcte_positive_changes_to_excercise, :string, :limit => 18
    
    if !FeeSchedule.exists?(32)
      FeeSchedule.create_with_id 32, :programme_id => 3, :code => 'DINF', :description => 'Diabetes Non Funded', :fee => 0.00, :gl_account_no => '03-0002'
    end
    if FeeSchedule.exists?(30)
      f=FeeSchedule.find(30)
      f.fee = 45.00
      f.save
    end

    ClaimsData.reset_column_information
    DataField.populate_table    
  end

  def self.down
    remove_column :claims_data, :oorm_other_oral_medication
    remove_column :claims_data, :omed_other_medication
    remove_column :claims_data, :pctd_positive_changes_to_diet
    remove_column :claims_data, :pcte_positive_changes_to_excercise
    FeeSchedule.delete [32] if FeeSchedule.exists?(32)
    ClaimsData.reset_column_information
    DataField.populate_table    
  end
end
