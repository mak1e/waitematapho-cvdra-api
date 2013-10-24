class CreateAgerangePmp < ActiveRecord::Migration
  def self.up
    puts "Adding agerange_pmp function"
    execute "CREATE FUNCTION agerange_pmp(@dob DATETIME, @asat DATETIME)\n"+
      "RETURNS VARCHAR(16)\n"+
      "AS\n"+
      "BEGIN\n"+
      "  DECLARE @retval  VARCHAR(16)\n"+
      "  DECLARE @age INTEGER\n"+
      "  SET @age = floor(datediff(dd,@dob,@asat)/365.2425)\n"+
      "  IF ( @age < 15 )\n"+
      "    SET @retval = '00..14'\n"+
      "  ELSE\n"+
      "  IF ( @age < 30 )\n"+
      "    SET @retval = '15..29'\n"+
      "  ELSE\n"+
      "  IF ( @age < 40 )\n"+
      "    SET @retval = '30..39'\n"+
      "  ELSE\n"+
      "  IF ( @age < 50 )\n"+
      "    SET @retval = '40..49'\n"+
      "  ELSE\n"+
      "  IF ( @age < 60 )\n"+
      "    SET @retval = '50..59'\n"+
      "  ELSE\n"+
      "  IF ( @age < 70 )\n"+
      "    SET @retval = '60..69'\n"+
      "  ELSE\n"+
      "  IF ( @age < 80 )\n"+
      "    SET @retval = '70..79'\n"+
      "  ELSE\n"+
      "    SET @retval = '80+'\n"+
      "  RETURN @retval\n"+
      "END\n"    
    
  end

  def self.down
    execute "DROP FUNCTION agerange_pmp"
  end
end
