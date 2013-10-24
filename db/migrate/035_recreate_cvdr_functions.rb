class RecreateCvdrFunctions < ActiveRecord::Migration
  def self.up
    execute "DROP FUNCTION cvdr"
    execute "DROP FUNCTION framingham_risk"
      
    execute "CREATE FUNCTION framingham_risk( @gen varchar(1), @age integer,\n"+
            "                       @sbp int, @smok varchar(18),\n"+
            "                       @tchdl decimal(8,2),\n"+
            "                       @diab varchar(18) ) \n"+
            "RETURNS integer\n"+
            "-- Calulate the CVD Risk using the framingham equation\n"+
            "-- ===================================================\n"+
            "AS\n"+
            "BEGIN\n"+
            "  DECLARE @gen01 float\n"+
            "  DECLARE @smok01 float\n"+
            "  DECLARE @diab01 float\n"+
            "  DECLARE @x float\n"+
            "  DECLARE @y float\n"+
            "  DECLARE @u float\n"+
            "  \n"+
            "  IF ( @sbp < 50 ) \n"+
            "    SET @sbp = NULL\n"+
            "  IF ( @sbp > 250 ) \n"+
            "    SET @sbp = NULL\n"+
            "  \n"+
            "  IF ( @tchdl < 1 ) \n"+
            "    SET @tchdl = NULL\n"+
            "  IF ( @tchdl > 12 ) \n"+
            "    SET @tchdl = NULL\n"+
            "  IF ( @diab is null )\n"+
            "    SET @diab = '' \n"+
            "  IF ( @smok is null )\n"+
            "    SET @smok = '' \n"+
            "  \n"+
            "  IF ( @gen is null ) OR ( @age is null )  OR ( @sbp is null ) OR ( @smok is null ) OR ( @tchdl is null ) OR ( @diab is null)\n"+
            "    RETURN CAST(NULL AS integer)\n"+
            "  if ( @age < 35 )\n"+
            "    SET @age = 35  \n"+
            "  if ( @age > 75 )\n"+
            "    SET @age = 75  \n"+
            "\n"+
            "\n"+
            "  SET @gen01 = 0\n"+
            "  IF ( @gen = 'F' ) OR ( @gen = 'f' ) \n"+
            "    SET @gen01 = 1\n"+
            "      \n"+
            "  SET @smok01 = 0\n"+
            "  IF @smok like 'yes%'\n"+
            "    SET @smok01 = 1\n"+
            "    \n"+
            "  SET @diab01 = 0\n"+
            "  IF ( @diab not like 'no%' ) AND ( @diab <> '' )  \n"+
            "    SET @diab01 = 1\n"+
            "    \n"+
            "  SET @x = 18.8144 - 1.2146*@gen01 - 1.8443*Log(@age) + 0.3668*Log(@age)*@gen01 \n"+
            "  SET @x = @x - 1.4032*Log(@sbp) - 0.3899*@smok01 - 0.539*Log(@tchdl)\n"+
            "  SET @x = @x - 0.3036*@diab01 - 0.1697*@diab01*@gen01\n"+
            "  SET @y = Exp(0.6536+(-0.2402*(@x)))\n"+
            "  SET @u = (Log(5)-(@x))/@y\n"+
            "  \n"+
            "  RETURN Round((1-Exp(-1*Exp(@u)))*100,0)\n"+
            "END"

    execute "CREATE FUNCTION calc_est_cvdr(\n"+
            " @age integer, @gen varchar(1), @eth integer, \n"+
            " @sbp  integer, @sbpp integer, @dbp integer, @dbpp integer,\n"+
            " @smok varchar(18), @tchdl decimal(8,2), @tc decimal(8,2), @hdl decimal(8,2),\n"+
            " @diab varchar(18), @yodd datetime, @fhcvd varchar(18),  @tia varchar(18),\n"+
            " @angi varchar(18), @ptca varchar(18), @pvd varchar(18), @dsma varchar(18),\n"+
            " @renal varchar(18), @hba1c decimal(8,2), @mets varchar(18),\n"+
            " @gld varchar(18), @trig decimal(8,2)\n"+
            ")\n"+
            "RETURNS integer\n"+
            "-- Calulate extimated CVD Risk using the framingham equation \n"+
            "-- Plus NZ Specific extensions for ethnicity, disease etc\n"+
            "AS\n"+
            "BEGIN\n"+
            "DECLARE @cvdr integer\n"+
            "\n"+
            "-- Calculate some values if nulll\n"+
            "if ( @sbpp is null ) OR ( @sbpp < 10 )\n"+
            "  SET @sbpp = @sbp\n"+
            "if ( @dbpp is null ) OR ( @dbpp < 10 )\n"+
            "  SET @dbpp = @dbp\n"+
            "if ( @tchdl is null ) and ( @tc > 0.1 ) and ( @hdl > 0.1 )\n"+
            "  SET @tchdl = @tc / @hdl\n"+
            "if ( @smok is null ) \n"+
            "  SET @smok = 'no'\n"+
            "if ( @diab is null ) \n"+
            "  SET @diab = 'no'\n"+
            "  \n"+
            "-- Calculate base risk\n"+
            "SET @cvdr=dbo.framingham_risk(@gen,@age,(@sbp+@sbpp)/2,@smok,@tchdl,@diab)\n"+
            "\n"+
            "-- Add 5% - For high risk groups\n"+
            "-- ==============================\n"+
            "-- If the patient does not meet exclusion criteria or is not clinically determined as being at\n"+
            "-- very high risk, then the Framingham risk calculation is performed. After this calculation,\n"+
            "-- the following groups should be moved up one risk category (5%), as their cardiovascular\n"+
            "-- risk may be underestimated in the Framingham equation\n"+
            "-- * People with a family history of premature coronary heart disease or ischaemic\n"+
            "-- stroke in a first degree male relative before the age of 55 years or a first degree\n"+
            "-- female relative before the age of 65yrs\n"+
            "-- * Maori\n"+
            "-- * Pacific peoples or people from Indian subcontinent\n"+
            "-- * People with both diabetes and microalbuminuria\n"+
            "-- * People who have had type 2 diabetes for more than 10 years or who have an HbA1c consistently greater than 8%\n"+
            "-- * People with metabolic syndrome\n"+
            "-- These adjustments should only be made once\n"+
            " \n"+
            "if ( @cvdr < 35 ) and ( (@eth = 21) or \n"+
            "     (@eth > 30 and @eth < 39) or\n"+
            "     (@eth= 43) or   \n"+
            "     (@fhcvd like 'y%' ) or\n"+
            "     (@tia like 'y%' ) or \n"+
            "     (@angi like 'y%' ) or \n"+
            "     (@ptca like 'y%' ) or \n"+
            "     (@pvd like 'y%' ) or \n"+
            "     (@diab  like 't%' and (@dsma like 'po%')) or\n"+
            "     (@diab  like 't%' and (@renal  like '%microalb%')) or\n"+
            "     (@diab  like 't%' and ((@yodd+10) < Year(GetDate()) or @hba1c > 8.0 )) or \n"+
            "     (@mets  like 'y%' )) \n"+
            "  SET @cvdr = @cvdr + 5\n"+
            "\n"+
            "-- Set to 15% - if extreme bp/cholesterol\n"+
            "-- ======================================\n"+
            "-- If a person's calculated and adjusted risk was less than 15% but the profile contained\n"+
            "-- extreme values of blood pressure or cholesterol then classification of CVD risk 15% was\n"+
            "-- undertaken when\n"+
            "-- * TC/HDL OR Total cholesterol greater than or equal to 8 mmol/L\n"+
            "-- * { (systolic BP1 was greater than or equal to 170mmHg or diastolic BP1 was\n"+
            "-- greater than or equal to 100mmHg) AND (systolic BP2 was greater than or equal\n"+
            "-- to 170mmHg or diastolic BP2 was greater than or equal to 100mmHg) }\n"+
            "\n"+
            "if ( @cvdr < 15 ) and ( (@tchdl > 8.0  ) or \n"+
            "     (@tc > 8.0  ) or\n"+
            "     ((@sbp > 170 or @dbp > 100) and (@sbpp > 170 or @dbpp > 100))) \n"+
            "  SET @cvdr = 15\n"+
            "  \n"+
            "-- Set to 35% - if clinically high\n"+
            "-- ======================================\n"+
            "if ( @cvdr < 35 ) and ((@angi like 'y%' ) or\n"+
            "     (@ptca like 'y%' ) or\n"+
            "     (@tia like 'y%' ) or  \n"+
            "     (@pvd like 'y%' ) or\n"+
            "     (@gld like 'famil%' ) or \n"+
            "     (@gld like 'other%' ) or \n"+
            "     (@diab like 't%' and (@renal like '%nep%')))\n"+
            "  SET @cvdr = 35\n"+
            "\n"+
            "RETURN @cvdr\n"+
            "\n"+
            "END"
      
      
  end

  def self.down
  end
end
