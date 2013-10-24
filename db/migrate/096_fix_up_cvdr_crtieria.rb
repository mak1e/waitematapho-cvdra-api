class FixUpCvdrCrtieria < ActiveRecord::Migration
  def self.up
    # Fixed Indian is 43 Only, Not 43 + Other Asian (44), Set Other Asian to be Other 
    Ethnicity.update_all( "ethnicity_cvdr = 'Indian', order_by_cvdr = 3", "id in ( 43 )" );
    Ethnicity.update_all( "ethnicity_cvdr = 'Other', order_by_cvdr = 5", "id in ( 44 )" );
    # Also the cvd_eligible, Has bug need to add Indian etc Males 35+ (not 45+), and Adjust Indian
    CreateCvdrEligFunc.down
    CreateCvdrEligFunc.up
    # Added cvd_eligible_noagelimit (Save as cvd_eligible but no upper limit on age )
    execute  "CREATE FUNCTION cvd_eligible_noagelimit(@date_of_birth DATETIME,@gender_id VARCHAR(1),@ethnicity_id INTEGER, @asat DATETIME )\n"+
       "-- Returns 1 if eligible, 0 if not\n"+
       "RETURNS integer\n"+
       "AS\n"+
       "BEGIN\n"+
       "  DECLARE @retval  float\n"+
       "  DECLARE @age INTEGER\n"+
       "  \n"+
       "  DECLARE @ageY INTEGER\n"+
       "  DECLARE @ageM INTEGER\n"+
       "  DECLARE @ageD INTEGER\n"+
       "\n"+
       "  SET @ageY = Year(@asat) - Year(@date_of_birth)\n"+
       "  SET @ageM = Month(@asat) - Month(@date_of_birth)\n"+
       "  SET @ageD = Day(@asat) - Day(@date_of_birth)\n"+
       "  \n"+
       "  IF ( @ageD < 0 )\n"+
       "  BEGIN\n"+
       "    SET @ageD = @ageD + 30\n"+
       "    SET @ageM = @ageM - 1\n"+
       "  END\n"+
       "\n"+
       "  IF ( @ageM < 0 )\n"+
       "  BEGIN\n"+
       "    SET @ageM = @ageM + 12\n"+
       "    SET @ageY = @ageY - 1\n"+
       "  END\n"+
       "  \n"+
       "  -- CVD Eliagability\n"+
       "  --   Males aged 45+\n"+
       "  --   Females aged 55+\n"+
       "  --   Maori/Pacific/Indian Male aged 35+\n"+
       "  --   Maori/Pacific/Indian Female aged 45+\n"+
       "  \n"+
       "  SET @retval = 0\n"+
       "  IF ( @ageY < 99 )\n"+
       "  BEGIN\n"+
       "    IF ( @ageY >= 55 ) -- Anyone aged 55+\n"+
       "      SET @retval = 1\n"+
       "    ELSE \n"+
       "    IF ( @ageY >= 45 ) and ( @gender_id = 'M' ) -- Males aged 45+\n"+
       "      SET @retval = 1\n"+
       "    ELSE \n"+
       "    IF ( @ethnicity_id = 21 ) or  -- Maori\n"+
       "       (( @ethnicity_id >= 30 ) and ( @ethnicity_id <= 37 )) or -- Pacific\n"+
       "       ( @ethnicity_id = 43 ) -- Indian\n"+
       "    BEGIN\n"+
       "      IF ( @ageY >= 45 ) -- Aged 45+\n"+
       "        SET @retval = 1\n"+
       "      ELSE \n"+
       "      IF ( @ageY >= 35 ) and ( @gender_id = 'M' ) -- Males aged 35+\n"+
       "        SET @retval = 1\n"+
       "    END\n"+
       "  END\n"+
       "  RETURN @retval\n"+
       "END"
    
  end

  def self.down
    execute  "DROP FUNCTION cvd_eligible_noagelimit"
  end
end
