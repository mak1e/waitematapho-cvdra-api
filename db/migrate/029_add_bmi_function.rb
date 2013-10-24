class AddBmiFunction < ActiveRecord::Migration
  def self.up
    execute "CREATE FUNCTION bmi( @weight_kg int, @height_cms int)\n"+
            "RETURNS integer\n"+
            "AS\n"+
            "BEGIN\n"+
            "  IF ( @height_cms is null ) OR ( @weight_kg is null ) OR ( @height_cms < 10 ) OR ( @weight_kg < 1 )\n"+
            "    RETURN CAST(NULL AS integer)\n"+
            "  RETURN Round( @weight_kg / Square( @height_cms / 100.0),0)  \n"+
            "END\n"
  end

  def self.down
  end
end
