class CreateEthnicityCvdr < ActiveRecord::Migration
  def self.up
     execute  "CREATE FUNCTION ethnicity_cvdr(@ethnicity_id INTEGER)\n"+
       "RETURNS VARCHAR(18)\n"+
       "AS\n"+
       "BEGIN\n"+
       "  DECLARE @retval  VARCHAR(18)\n"+
       "  IF ( @ethnicity_id >= 10 )  and ( @ethnicity_id < 19 )  \n"+
       "    SET @retval = '1-European'\n"+
       "  ELSE\n"+
       "  IF ( @ethnicity_id >= 20 )  and ( @ethnicity_id < 29 )  \n"+
       "    SET @retval = '2-Maori'\n"+
       "  ELSE\n"+
       "  IF ( @ethnicity_id >= 30 )  and ( @ethnicity_id < 39 )  \n"+
       "    SET @retval = '3-Pacific I'\n"+
       "  ELSE\n"+
       "  IF ( @ethnicity_id = 43 ) \n"+
       "    SET @retval = '43-Indian'\n"+
       "  ELSE\n"+
       "  IF ( @ethnicity_id >= 40 )  and ( @ethnicity_id < 49 )  \n"+
       "    SET @retval = '4-Asian'\n"+
       "  ELSE\n"+
       "    SET @retval = '5-Other'\n"+
       "  RETURN @retval\n"+
       "END"
  end

  def self.down
  end


end
