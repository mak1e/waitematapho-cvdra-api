class CreateAgerange10y < ActiveRecord::Migration
  def self.up
    execute "CREATE FUNCTION agerange_10y(@dob DATETIME, @asat DATETIME)\n"+
      "RETURNS VARCHAR(16)\n"+
      "AS\n"+
      "BEGIN\n"+
      "  DECLARE @retval  VARCHAR(16)\n"+
      "  DECLARE @age INTEGER\n"+
      "  SET @age = floor(datediff(dd,@dob,@asat)/365.2425)\n"+
      "  IF ( @age <= 5 )\n"+
      "    SET @retval = '00..04'\n"+
      "  ELSE\n"+
      "  IF ( @age <= 14 )\n"+
      "    SET @retval = '05..14'\n"+
      "  ELSE\n"+
      "  IF ( @age <= 24 )\n"+
      "    SET @retval = '15..24'\n"+
      "  ELSE\n"+
      "  IF ( @age <= 34 )\n"+
      "    SET @retval = '25..34'\n"+
      "  ELSE\n"+
      "  IF ( @age <= 44 )\n"+
      "    SET @retval = '35..44'\n"+
      "  ELSE\n"+
      "  IF ( @age <= 54 )\n"+
      "    SET @retval = '45..54'\n"+
      "  ELSE\n"+
      "  IF ( @age <= 64 )\n"+
      "    SET @retval = '55..64'\n"+
      "  ELSE\n"+
      "  IF ( @age <= 74 )\n"+
      "    SET @retval = '65..74'\n"+
      "  ELSE\n"+
      "    SET @retval = '75+'\n"+
      "  RETURN @retval\n"+
      "END\n"        
  end

  def self.down
  end
end
