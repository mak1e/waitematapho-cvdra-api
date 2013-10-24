class CplusEligibleFn < ActiveRecord::Migration
  def self.up
    execute "CREATE FUNCTION [dbo].[cplus_eligible](@date_of_birth DATETIME,@gender_id VARCHAR(1),@ethnicity_id INTEGER,@quintile INTEGER, @asat DATETIME )\n"+
            "RETURNS float\n"+
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
            "  SET @retval = 0.0\n"+
            "  IF ( @ageY < 5 )\n"+
            "  BEGIN\n"+
            "    -- 00-04\n"+
            "    IF ( @gender_id = 'F' )\n"+
            "      BEGIN\n"+
            "       IF ( @ethnicity_id >= 20 )  and ( @ethnicity_id < 40 ) -- Maori/Pi\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 2.60 -- Female Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 2.30 -- Female Maori/Pi Dep < 5\n"+
            "         END\n"+
            "       ELSE\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 2.20 -- Female NON Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 1.50 -- Female NON Maori/Pi Dep < 5\n"+
            "         END\n"+
            "      END\n"+
            "    ELSE\n"+
            "      BEGIN\n"+
            "       IF ( @ethnicity_id >= 20 )  and ( @ethnicity_id < 40 ) -- Maori/Pi\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 3.10 -- Male Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 2.00 -- Male Maori/Pi Dep < 5\n"+
            "         END\n"+
            "       ELSE\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 1.90 -- Male NON Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 1.70 -- Male NON Maori/Pi Dep < 5\n"+
            "         END\n"+
            "      END\n"+
            "  END\n"+
            "  ELSE\n"+
            "  IF ( @ageY < 15 )\n"+
            "  BEGIN\n"+
            "    -- 05-14\n"+
            "    IF ( @gender_id = 'F' )\n"+
            "      BEGIN\n"+
            "       IF ( @ethnicity_id >= 20 )  and ( @ethnicity_id < 40 ) -- Maori/Pi\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 1.40 -- Female Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 1.30 -- Female Maori/Pi Dep < 5\n"+
            "         END\n"+
            "       ELSE\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 1.20 -- Female NON Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 1.10 -- Female NON Maori/Pi Dep < 5\n"+
            "         END\n"+
            "      END\n"+
            "    ELSE\n"+
            "      BEGIN\n"+
            "       IF ( @ethnicity_id >= 20 )  and ( @ethnicity_id < 40 ) -- Maori/Pi\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 1.60 -- Male Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 0.90 -- Male Maori/Pi Dep < 5\n"+
            "         END\n"+
            "       ELSE\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 0.80 -- Male NON Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 0.70 -- Male NON Maori/Pi Dep < 5\n"+
            "         END\n"+
            "      END\n"+
            "  END\n"+
            "  ELSE\n"+
            "  IF ( @ageY < 25 )\n"+
            "  BEGIN\n"+
            "    -- 15-24\n"+
            "    IF ( @gender_id = 'F' )\n"+
            "      BEGIN\n"+
            "       IF ( @ethnicity_id >= 20 )  and ( @ethnicity_id < 40 ) -- Maori/Pi\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 3.40 -- Female Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 3.30 -- Female Maori/Pi Dep < 5\n"+
            "         END\n"+
            "       ELSE\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 2.50 -- Female NON Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 1.40 -- Female NON Maori/Pi Dep < 5\n"+
            "         END\n"+
            "      END\n"+
            "    ELSE\n"+
            "      BEGIN\n"+
            "       IF ( @ethnicity_id >= 20 )  and ( @ethnicity_id < 40 ) -- Maori/Pi\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 1.70 -- Male Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 1.60 -- Male Maori/Pi Dep < 5\n"+
            "         END\n"+
            "       ELSE\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 1.50 -- Male NON Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 0.50 -- Male NON Maori/Pi Dep < 5\n"+
            "         END\n"+
            "      END\n"+
            "  END\n"+
            "  ELSE\n"+
            "  IF ( @ageY < 45 )\n"+
            "  BEGIN\n"+
            "    -- 25-44\n"+
            "    IF ( @gender_id = 'F' )\n"+
            "      BEGIN\n"+
            "       IF ( @ethnicity_id >= 20 )  and ( @ethnicity_id < 40 ) -- Maori/Pi\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 4.30 -- Female Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 3.80 -- Female Maori/Pi Dep < 5\n"+
            "         END\n"+
            "       ELSE\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 2.60 -- Female NON Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 2.40 -- Female NON Maori/Pi Dep < 5\n"+
            "         END\n"+
            "      END\n"+
            "    ELSE\n"+
            "      BEGIN\n"+
            "       IF ( @ethnicity_id >= 20 )  and ( @ethnicity_id < 40 ) -- Maori/Pi\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 3.60 -- Male Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 3.10 -- Male Maori/Pi Dep < 5\n"+
            "         END\n"+
            "       ELSE\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 1.60 -- Male NON Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 1.30 -- Male NON Maori/Pi Dep < 5\n"+
            "         END\n"+
            "      END\n"+
            "  END\n"+
            "  ELSE\n"+
            "  IF ( @ageY < 65 )\n"+
            "  BEGIN\n"+
            "    -- 45-64\n"+
            "    IF ( @gender_id = 'F' )\n"+
            "      BEGIN\n"+
            "       IF ( @ethnicity_id >= 20 )  and ( @ethnicity_id < 40 ) -- Maori/Pi\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 13.90 -- Female Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 13.80 -- Female Maori/Pi Dep < 5\n"+
            "         END\n"+
            "       ELSE\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 8.50 -- Female NON Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 4.80 -- Female NON Maori/Pi Dep < 5\n"+
            "         END\n"+
            "      END\n"+
            "    ELSE\n"+
            "      BEGIN\n"+
            "       IF ( @ethnicity_id >= 20 )  and ( @ethnicity_id < 40 ) -- Maori/Pi\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 16.70 -- Male Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 15.90 -- Male Maori/Pi Dep < 5\n"+
            "         END\n"+
            "       ELSE\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 9.30 -- Male NON Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 6.00 -- Male NON Maori/Pi Dep < 5\n"+
            "         END\n"+
            "      END\n"+
            "  END\n"+
            "  ELSE\n"+
            "  BEGIN\n"+
            "    -- 65+\n"+
            "    IF ( @gender_id = 'F' )\n"+
            "      BEGIN\n"+
            "       IF ( @ethnicity_id >= 20 )  and ( @ethnicity_id < 40 ) -- Maori/Pi\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 33.80 -- Female Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 29.20 -- Female Maori/Pi Dep < 5\n"+
            "         END\n"+
            "       ELSE\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 22.40 -- Female NON Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 18.40 -- Female NON Maori/Pi Dep < 5\n"+
            "         END\n"+
            "      END\n"+
            "    ELSE\n"+
            "      BEGIN\n"+
            "       IF ( @ethnicity_id >= 20 )  and ( @ethnicity_id < 40 ) -- Maori/Pi\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 41.00 -- Male Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 37.20 -- Male Maori/Pi Dep < 5\n"+
            "         END\n"+
            "       ELSE\n"+
            "         BEGIN\n"+
            "           IF ( @quintile = 5 )\n"+
            "             SET @retval = 24.70 -- Male NON Maori/Pi Dep 5\n"+
            "           ELSE\n"+
            "             SET @retval = 21.20 -- Male NON Maori/Pi Dep < 5\n"+
            "         END\n"+
            "      END\n"+
            "  END\n"+
            "  RETURN @retval\n"+
            "END\n"
  end

  def self.down
    execute "DROP FUNCTION cplus_eligible"
  end
end
