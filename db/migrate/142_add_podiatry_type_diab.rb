class AddPodiatryTypeDiab < ActiveRecord::Migration
  def self.up
    if ( Programme.exists?(23) )
      puts "Adding Type of Diabetes to Podiatory"
      
      ProgrammeElement.populate(23, [
      { :position => 0, :column_name => 'diab_type_of_diabetes'},# On Referral
      
      { :position => 4,  :column_name => 'rfiskc_foot_risk_category'},# Ist and Single assessment only
      
      { :position => 8,  :column_name => 'podref_podiatary_referral'},
      { :position => 9,  :column_name => 'podref_podiatary_referral2'} ]);
    end
  end
  
  def self.down
  end
end
