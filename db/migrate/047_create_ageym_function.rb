class CreateAgeymFunction < ActiveRecord::Migration
  def self.up
    execute "CREATE FUNCTION AGEym(@dob DATETIME, @asat DATETIME)\n"+
            "RETURNS VARCHAR(8)\n"+
            "AS\n"+
            "BEGIN\n"+
            "  DECLARE @ageY INTEGER\n"+
            "  DECLARE @ageM INTEGER\n"+
            "  DECLARE @ageD INTEGER\n"+
            "  DECLARE @retval VARCHAR(8)\n"+
            "\n"+
            "  SET @ageY = Year(@asat) - Year(@dob)\n"+
            "  SET @ageM = Month(@asat) - Month(@dob)\n"+
            "  SET @ageD = Day(@asat) - Day(@dob)\n"+
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
            "  SET @retval = CAST( @ageM as VARCHAR(3) ) + 'm'\n"+
            "  IF ( @ageM < 10 ) \n"+
            "    SET @retval = ' ' + @retval\n"+
            "  SET @retval = CAST( @ageY as VARCHAR(3) ) + 'y ' + @retval\n"+
            "  IF ( @ageY < 10 ) \n"+
            "    SET @retval = ' ' + @retval; \n"+
            "  RETURN @retval\n"+
            "END\n"
  end

  def self.down
  end
end
