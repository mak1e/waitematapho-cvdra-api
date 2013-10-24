class CreateHighneedsFunctions < ActiveRecord::Migration
  
  def self.up
    execute "CREATE FUNCTION dep5(@quintile INTEGER)\n"+
            "RETURNS VARCHAR(18)\n"+
            "AS\n"+
            "BEGIN\n"+
            "  DECLARE @retval  VARCHAR(18)\n"+
            "  IF ( @quintile = 5 )\n"+
            "    SET @retval = 'Dep 5'\n"+
            "  ELSE\n"+
            "    SET @retval = 'Dep <5'\n"+
            "  RETURN @retval\n"+
            "END"

    execute "CREATE FUNCTION maoripi(@ethnicity_id INTEGER)\n"+
            "RETURNS VARCHAR(18)\n"+
            "AS\n"+
            "BEGIN\n"+
            "  DECLARE @retval  VARCHAR(18)\n"+
            "  IF ( @ethnicity_id >= 20 )  and ( @ethnicity_id < 40 )\n"+
            "    SET @retval = 'Maori/Pacific'\n"+
            "  ELSE\n"+
            "    SET @retval = 'Non Maori/Pacific'\n"+
            "  RETURN @retval\n"+
            "END"
  
  
  end

  def self.down
  end


end
