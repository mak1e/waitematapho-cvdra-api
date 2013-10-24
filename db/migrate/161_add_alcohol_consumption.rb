class AddAlcoholConsumption < ActiveRecord::Migration
  def self.up
    puts "Add Alcohol Consumption"
    # caalc_alcohol_consumption is a boolean (but not used) change to a string !!
    remove_column :claims_data, :caalc_alcohol_consumption
    add_column :claims_data, :alcs_alcohol_consumption  , :string, :limit => 18
    add_column :claims_data, :alar_alcohol_at_risk  , :string, :limit => 18
    
    ClaimsData.reset_column_information
    DataField.populate_table
    
    if ( Programme.exists?(25) )
  
      # Reporting requirements:- the number of patients who       
      # i.  score above upper limits of the guidelines.
      # ii. score within the guidelines but their alcohol consumption is a potential risk given their underlying health/other factors.
      # iii.  receive brief advice from clinical staff.
      # iv. are referred for AOD counselling, and where they are referred to.
      # v.  are referred for extended consultation within the practice.
      # vi.  are referred to specialist AOD services
      # vii.  receive the full AUDIT
      # viii. respond affirmatively to question 9 of the full AUDIT (injury question) as well as a breakdown of whether the injury occurred within the last year or not.
      
      
      ProgrammeElement.populate(25, [ 
                    { :position => 0,  :column_name => 'alcs_alcohol_consumption', :report_by => 'count(distinct claims.patient_id)'},
                    { :position => 1,  :column_name => 'alar_alcohol_at_risk', :report_by => 'claims_data.alcs_alcohol_consumption'},
                    
                    { :position => 4,  :column_name => 'alus_alcohol_under_surveillance'},
                    { :position => 5,  :column_name => 'alfq_alcohol_frequency'},
                    { :position => 6,  :column_name => 'alds_alcohol_drinks_per_session'},
                    { :position => 7,  :column_name => 'albf_alcohol_binge_frequency'},
                    
                    { :position => 8,  :column_name => 'dcsa_drink_check_section_a'},
                    { :position => 9,  :column_name => 'dcsb_drink_check_section_b'},
                    { :position => 10,  :column_name => 'dcsc_drink_check_section_c'},
                    { :position => 11,  :column_name => 'abass_abuse_assessment', :report_by => 'count(distinct claims.patient_id)'},

                    { :position => 12,  :column_name => 'refto_Referral_To', :report_by => 'count(distinct claims.patient_id)'},
                    
                    { :position => 16,  :column_name => 'alag_alcohol_advice_given', :report_by => 'count(distinct claims.patient_id)'},
                    { :position => 17,  :column_name => 'preg_pregnant', :report_by => 'count(distinct claims.patient_id)'},
                    { :position => 18,  :column_name => 'alrc_alcohol_readiness_to_change'}]);
    end
  end

  def self.down
  end
end
