class AddCvdrFunctions < ActiveRecord::Migration
  def self.up
    execute "CREATE FUNCTION framingham_risk( @gender varchar(1), @age integer,\n"+
            "                       @sysbp int, @smoking varchar(18),\n"+
            "                       @tchdlratio decimal(8,2),\n"+
            "                       @diabetes varchar(18) ) \n"+
            "RETURNS integer\n"+
            "AS\n"+
            "BEGIN\n"+
            "  DECLARE @gender01 float\n"+
            "  DECLARE @smoking01 float\n"+
            "  DECLARE @diabetes01 float\n"+
            "  DECLARE @x float\n"+
            "  DECLARE @y float\n"+
            "  DECLARE @u float\n"+
            "  \n"+
            "  IF ( @gender is null ) OR ( @age is null )  OR ( @sysbp is null ) OR ( @smoking is null ) OR ( @tchdlratio is null ) OR ( @diabetes is null)\n"+
            "    RETURN CAST(NULL AS integer)\n"+
            "  if ( @age < 35 )\n"+
            "    SET @age = 35  \n"+
            "  if ( @age > 75 )\n"+
            "    SET @age = 75  \n"+
            "\n"+
            "\n"+
            "  SET @gender01 = 0\n"+
            "  IF @gender = 'F'\n"+
            "    SET @gender01 = 1\n"+
            "      \n"+
            "  SET @smoking01 = 0\n"+
            "  IF @smoking like 'Yes%'\n"+
            "    SET @smoking01 = 1\n"+
            "    \n"+
            "  SET @diabetes01 = 0\n"+
            "  IF ( @diabetes not like 'No%' ) AND ( @diabetes <> '' )  \n"+
            "    SET @diabetes01 = 1\n"+
            "    \n"+
            "  SET @x = 18.8144 - 1.2146*@gender01 - 1.8443*Log(@age) + 0.3668*Log(@age)*@gender01 \n"+
            "  SET @x = @x - 1.4032*Log(@sysbp) - 0.3899*@smoking01 - 0.539*Log(@tchdlratio)\n"+
            "  SET @x = @x - 0.3036*@diabetes01 - 0.1697*@diabetes01*@gender01\n"+
            "  SET @y = Exp(0.6536+(-0.2402*(@x)))\n"+
            "  SET @u = (Log(5)-(@x))/@y\n"+
            "  \n"+
            "  RETURN Round((1-Exp(-1*Exp(@u)))*100,0)\n"+
            "END;\n"
             
             
    execute "CREATE FUNCTION cvdr(@claim_id integer)\n"+
            "RETURNS integer\n"+
            "AS\n"+
            "BEGIN\n"+
            "DECLARE @cvdr integer\n"+
            "DECLARE @gen varchar(1), @age integer, @sbp  integer, @sbpp integer, @dbp integer, @dbpp integer\n"+
            "DECLARE @smok varchar(18), @tchdl decimal(8,2), @tc  decimal(8,2), @hdl decimal(8,2)\n"+
            "DECLARE @diab varchar(18), @eth integer, @fhcvd varchar(18), @tia varchar(18)\n"+
            "DECLARE @angi varchar(18), @ptca varchar(18), @pvd varchar(18), @dsma varchar(18)\n"+
            "DECLARE @renal varchar(18), @yodd datetime, @hba1c decimal(8,2), @mets varchar(18)\n"+
            "DECLARE @gld varchar(18)\n"+
            "\n"+
            "\n"+
            "select @gen = p.gender_id, @age=dbo.age(p.date_of_birth, GetDate()),\n"+
            "      @sbp = d.sbp_systolic_blood_pressure, @sbpp=d.sbpp_systolic_blood_pressure_previous,\n"+
            "      @dbp = d.dbp_diastolic_blood_pressure, @dbpp=d.dbpp_diastolic_blood_pressure_previous,\n"+
            "      @smok = d.smok_smoking_history, @tchdl = d.tchdl_tc_hdl_ratio, \n"+
            "      @tc = d.tc_total_cholesterol, @hdl = d.hdl_hdl_cholesterol, \n"+
            "      @diab = d.diab_type_of_diabetes, @eth = p.ethnicity_id, \n"+
            "      @fhcvd = d.fhcvd_family_history_early_cardiovascular_disease, @tia = d.tia_stroke_tia, \n"+
            "      @angi = d.angi_angina_ami, @ptca = d.ptca_ptca_cabg, \n"+
            "      @pvd = d.pvd_peripheral_vessel_disease, @dsma = d.dsma_dipstick_test_for_microalbuminuria, \n"+
            "      @renal = d.renal_established_renal_disease, @yodd = d.yodd_year_of_diabetes_diagnosis, \n"+
            "      @hba1c = d.hba1c_hba1c, @mets = d.mets_diagnosed_metabolic_syndrome, \n"+
            "      @gld = d.gld_genetic_lipid_disorder \n"+
            "from claims c \n"+
            "  left join claims_data d on d.id = c.id \n"+
            "    left join patients p on p.id = c.patient_id\n"+
            "where c.id = @claim_id\n"+
            "\n"+
            "-- Default values if null\n"+
            "if ( @sbpp is null ) OR ( @sbpp < 10 )\n"+
            "  SET @sbpp = @sbp\n"+
            "if ( @dbpp is null ) OR ( @dbpp < 10 )\n"+
            "  SET @dbpp = @dbp\n"+
            "if ( @tchdl is null ) and ( @tc > 0.1 ) and ( @hdl > 0.1 )\n"+
            "  SET @tchdl = @tc / @hdl\n"+
            "if ( @smok is null ) \n"+
            "  SET @smok = 'No'\n"+
            "if ( @diab is null ) \n"+
            "  SET @diab = 'No'\n"+
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
            "     (@fhcvd like 'Y%' ) or\n"+
            "     (@tia like 'Y%' ) or \n"+
            "     (@angi like 'Y%' ) or \n"+
            "     (@ptca like 'Y%' ) or \n"+
            "     (@pvd like 'Y%' ) or \n"+
            "     (@diab  like 'T%' and (@dsma like 'P%')) or\n"+
            "     (@diab  like 'T%' and (@renal  like '%microalb%')) or\n"+
            "     (@diab  like 'T%' and ((@yodd+10) < Year(GetDate()) or @hba1c > 8.0 )) or \n"+
            "     (@mets  like 'Y%' )) \n"+
            "  SET @cvdr = @cvdr + 5\n"+
            "\n"+
            "-- Set to 15% - if extreme bp/cholesterol\n"+
            "-- ======================================\n"+
            "-- If a person�s calculated and adjusted risk was less than 15% but the profile contained\n"+
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
            "if ( @cvdr < 35 ) and ((@angi like 'Y%' ) or\n"+
            "     (@ptca like 'Y%' ) or\n"+
            "     (@tia like 'Y%' ) or  \n"+
            "     (@pvd like 'Y%' ) or\n"+
            "     (@gld like 'Famil%' ) or \n"+
            "     (@gld like 'Other%' ) or \n"+
            "     (@diab like 'T%' and (@renal like '%nep%')))\n"+
            "  SET @cvdr = 35\n"+
            "\n"+
            "RETURN @cvdr\n"+
            "\n"+
            "END\n"

  end

  def self.down
  end
end
