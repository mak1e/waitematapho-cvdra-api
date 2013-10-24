class AdjustMhealthReminders < ActiveRecord::Migration
  def self.up
    change_column :claims_data, :smok_smoking_history, :string, :limit => 20
    if ( Programme.exists?(8) )
      FeeSchedule.find(:all,'programme_id = 8 and id < 818').each do |f|
         f.reminder_on = true
         f.reminder_in_weeks = 5
         f.reminder_note = 'No activity'
         if ( f.id == 800 )
           f.reminder_note = 'Referral not actioned'
         end
         if ( f.id == 802 )
           f.reminder_in_weeks = 1
           f.reminder_note = 'Completion Missing'
         end
         f.save!
     end
     ClaimsData.update_all("qolr_quality_of_life_rating = '10'", "qolr_quality_of_life_rating = '00-14'");
     ClaimsData.update_all("qolr_quality_of_life_rating = '20'", "qolr_quality_of_life_rating = '15-24'");
     ClaimsData.update_all("qolr_quality_of_life_rating = '40'", "qolr_quality_of_life_rating = '25-49'");
     ClaimsData.update_all("qolr_quality_of_life_rating = '60'", "qolr_quality_of_life_rating = '50-74'");
     ClaimsData.update_all("qolr_quality_of_life_rating = '80'", "qolr_quality_of_life_rating = '75+'");
   end
   DataField.update_all("choices = null, data_type = 'integer'","column_name = 'qolr_quality_of_life_rating'");
  end

  def self.down
  end
end
