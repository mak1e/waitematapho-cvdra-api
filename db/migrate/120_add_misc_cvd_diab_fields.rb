class AddMiscCvdDiabFields < ActiveRecord::Migration
  def self.up
    add_column :claims_data, :ohyp_other_hypoglycaemic_medication, :string, :limit => 18
    add_column :claims_data, :podr_podiatry_referral_today, :string, :limit => 18
  end

  def self.down
    remove_column :claims_data, :ohyp_other_hypoglycaemic_medication
    remove_column :claims_data, :podr_podiatry_referral_today
   # remove_column :claims_data, :rfiskc_foot_risk_category
  end
end
