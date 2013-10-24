class CreateAgerangeImm < ActiveRecord::Migration
  def self.up
    execute "CREATE FUNCTION [dbo].[agerange_imm](@dob DATETIME, @asat DATETIME)\n"+
      "RETURNS VARCHAR(9)\n"+
      "AS\n"+
      "BEGIN\n"+
      "  DECLARE @ageY INTEGER\n"+
      "  DECLARE @ageM INTEGER\n"+
      "  DECLARE @ageD INTEGER\n"+
      "  DECLARE @retval VARCHAR(9)\n"+
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
      "  IF ( @ageY <= 5 )\n"+
      "    BEGIN\n"+
      "      SET @retval = 'ERROR'\n"+
      "      IF ( @ageY < 1 )\n"+
      "        BEGIN\n"+
      "          IF ( @ageM < 6 )\n"+
      "            SET @retval = '   < 6m'\n"+
      "          ELSE\n"+
      "            SET @retval = '  6m..<1y'\n"+
      "        END\n"+
      "      ELSE\n"+
      "      IF ( @ageY <= 1 )\n"+
      "        SET @retval = ' 1y'\n"+
      "      ELSE\n"+
      "      IF ( @ageY <= 3 )\n"+
      "        SET @retval = ' 2..3y'\n"+
      "      ELSE\n"+
      "        SET @retval = ' 4..5y'\n"+
      "    END\n"+
      "  ELSE\n"+
      "  IF ( @ageY <= 17 )\n"+
      "    SET @retval = ' 6..17y'\n"+
      "  ELSE\n"+
      "  IF ( @ageY <= 24 )\n"+
      "    SET @retval = '18..24y'\n"+
      "  ELSE\n"+
      "  IF ( @ageY <= 44 )\n"+
      "    SET @retval = '25..44y'\n"+
      "  ELSE\n"+
      "  IF ( @ageY <= 64 )\n"+
      "    SET @retval = '45..64y'\n"+
      "  ELSE\n"+
      "    SET @retval = '65y+'\n"+
      "  RETURN @retval\n"+
      "END\n";
    
  end

  def self.down
    execute "DROP FUNCTION [dbo].[agerange_imm]"
  end
end
