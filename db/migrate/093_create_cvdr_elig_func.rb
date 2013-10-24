class CreateCvdrEligFunc < ActiveRecord::Migration
  def self.up
        execute  "CREATE FUNCTION cvd_eligible(@date_of_birth DATETIME,@gender_id VARCHAR(1),@ethnicity_id INTEGER, @asat DATETIME )\n"+
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
       "  --   Males aged 45..<75\n"+
       "  --   Females aged 55..<75\n"+
       "  --   Maori/Pacific/Indian Male aged 35..<75\n"+
       "  --   Maori/Pacific/Indian Female aged 45..<75\n"+
       "  \n"+
       "  SET @retval = 0\n"+
       "  IF ( @ageY < 75 )\n"+
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
    execute  "DROP FUNCTION cvd_eligible"
  end
end
