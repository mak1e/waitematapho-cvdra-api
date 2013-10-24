class CreateAgerangeGms < ActiveRecord::Migration
  def self.up
    execute "CREATE FUNCTION agerange_gms(@dob DATETIME, @asat DATETIME)\n"+
      "RETURNS VARCHAR(16)\n"+
      "AS\n"+
      "BEGIN\n"+
      "  DECLARE @retval  VARCHAR(16)\n"+
      "  DECLARE @age INTEGER\n"+
      "  SET @age = floor(datediff(dd,@dob,@asat)/365.2425)\n"+
      "  IF ( @age <= 5 )\n"+
      "    SET @retval = '00..05'\n"+
      "  ELSE\n"+
      "  IF ( @age <= 17 )\n"+
      "    SET @retval = '06..17'\n"+
      "  ELSE\n"+
      "  IF ( @age <= 24 )\n"+
      "    SET @retval = '18..24'\n"+
      "  ELSE\n"+
      "  IF ( @age <= 44 )\n"+
      "    SET @retval = '25..44'\n"+
      "  ELSE\n"+
      "  IF ( @age <= 64 )\n"+
      "    SET @retval = '45..64'\n"+
      "  ELSE\n"+
      "    SET @retval = '65+'\n"+
      "  RETURN @retval\n"+
      "END\n"    
  end

  def self.down
  end
end
