class AddB4schoolRefDates < ActiveRecord::Migration
  def self.up
    add_column :claims_data,:chqred_child_heath_q_referral_date , :date
    add_column :claims_data,:immred_immunisation_referral_date, :date
    add_column :claims_data,:growred_growth_measure_referral_date, :date
    add_column :claims_data,:dentred_dental_referral_date, :date
    add_column :claims_data,:vishrd_vision_hearing_referral_date, :date
    add_column :claims_data,:pedsrefd_peds_referral_date, :date
    add_column :claims_data,:sdqrefd_sdq_referral_date, :date
    add_column :claims_data,:pedsref2d_peds_referral_2_date, :date
    add_column :claims_data,:sdqref2d_sdq_referral_2_date, :date
    
    ClaimsData.reset_column_information
    DataField.populate_table
    
  end

  def self.down
    remove_column :claims_data,:chqred_child_heath_q_referral_date
    remove_column :claims_data,:immred_immunisation_referral_date
    remove_column :claims_data,:growred_growth_measure_referral_date
    remove_column :claims_data,:dentred_dental_referral_date
    remove_column :claims_data,:vishrd_vision_hearing_referral_date
    remove_column :claims_data,:pedsrefd_peds_referral_date
    remove_column :claims_data,:sdqrefd_sdq_referral_date
    remove_column :claims_data,:pedsref2d_peds_referral_2_date
    remove_column :claims_data,:sdqref2d_sdq_referral_2_date
  end
end
