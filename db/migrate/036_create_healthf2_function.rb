class CreateHealthf2Function < ActiveRecord::Migration
  def self.up
     execute  "CREATE FUNCTION healthf2(@patient_id integer)\n"+
              "-- Calculate health factors for the patient, Were there are more than two (2)\n"+
              "RETURNS varchar(250)\n"+
              "AS\n"+
              "BEGIN\n"+
              "DECLARE @result varchar(250), @hits integer\n"+
              "\n"+
              "DECLARE @age integer, @gen varchar(1), @eth integer \n"+
              "DECLARE @heig integer, @weig integer, @waist integer\n"+
              "DECLARE @sbp  integer, @sbpp integer, @dbp integer, @dbpp integer\n"+
              "DECLARE @smok varchar(18), @tchdl decimal(8,2), @tc decimal(8,2), @hdl decimal(8,2)\n"+
              "DECLARE @diab varchar(18), @yodd datetime, @fhcvd varchar(18),  @tia varchar(18)\n"+
              "DECLARE @angi varchar(18), @ptca varchar(18), @pvd varchar(18), @dsma varchar(18)\n"+
              "DECLARE @renal varchar(18), @hba1c decimal(8,2), @mets varchar(18)\n"+
              "DECLARE @gld varchar(18), @trig decimal(8,2)\n"+
              "DECLARE @cvdr decimal(8,2)\n"+
              "\n"+
              "DECLARE @age_n integer, @gen_n varchar(1),  @eth_n integer\n"+
              "DECLARE @heig_n integer, @weig_n integer, @waist_n integer\n"+
              "DECLARE @sbp_n integer, @sbpp_n integer, @dbp_n integer, @dbpp_n integer\n"+
              "DECLARE @smok_n varchar(18), @tchdl_n decimal(8,2), @tc_n decimal(8,2), @hdl_n decimal(8,2)\n"+
              "DECLARE @diab_n varchar(18),  @yodd_n datetime,  @fhcvd_n varchar(18), @tia_n varchar(18)\n"+
              "DECLARE @angi_n varchar(18), @ptca_n varchar(18), @pvd_n varchar(18), @dsma_n varchar(18)\n"+
              "DECLARE @renal_n varchar(18), @hba1c_n decimal(8,2), @mets_n varchar(18)\n"+
              "DECLARE @gld_n varchar(18), @trig_n decimal(8,2)\n"+
              "DECLARE @cvdr_n decimal(8,2)\n"+
              "\n"+
              "DECLARE @est_cvdr integer, @bmi integer, @OBESE_WAIST integer\n"+
              "\n"+
              "DECLARE cc CURSOR LOCAL FOR \n"+
              "select dbo.age(p.date_of_birth, GetDate()),  p.gender_id, p.ethnicity_id,\n"+
              "       d.heig_height, d.weig_weight, d.waist_waist_circumference, \n"+
              "       d.sbp_systolic_blood_pressure, d.sbpp_systolic_blood_pressure_previous,\n"+
              "       d.dbp_diastolic_blood_pressure, d.dbpp_diastolic_blood_pressure_previous,\n"+
              "       LOWER(d.smok_smoking_history), d.tchdl_tc_hdl_ratio, \n"+
              "       d.tc_total_cholesterol, d.hdl_hdl_cholesterol,\n"+
              "       LOWER(d.diab_type_of_diabetes), d.yodd_year_of_diabetes_diagnosis, d.fhcvd_family_history_early_cardiovascular_disease,  \n"+
              "       LOWER(d.tia_stroke_tia), LOWER(d.angi_angina_ami), LOWER(d.ptca_ptca_cabg), \n"+
              "       LOWER(d.pvd_peripheral_vessel_disease), LOWER(d.dsma_dipstick_test_for_microalbuminuria), \n"+
              "       LOWER(d.renal_established_renal_disease), LOWER(d.mets_diagnosed_metabolic_syndrome), \n"+
              "       LOWER(d.gld_genetic_lipid_disorder), \n"+
              "       d.trig_triglyceride, d.hba1c_hba1c, d.cvdr_cvd_risk\n"+
              "from claims c \n"+
              "  left join claims_data d on d.id = c.id \n"+
              "    left join patients p on p.id = c.patient_id\n"+
              "where c.patient_id = @patient_id and c.invoice_date < DateAdd(mm,-18,GetDate())\n"+
              "order by c.invoice_date desc\n"+
              "FOR READ ONLY; \n"+
              "       \n"+
              "\n"+
              "SET @result = NULL\n"+
              "\n"+
              "OPEN cc\n"+
              "FETCH NEXT FROM cc \n"+
              "INTO @age, @gen, @eth,\n"+
              "     @heig, @weig, @waist, \n"+
              "     @sbp, @sbpp,\n"+
              "     @dbp, @dbpp,\n"+
              "     @smok, @tchdl, \n"+
              "     @tc, @hdl,\n"+
              "     @diab, @yodd, @fhcvd, \n"+
              "     @tia, @angi, @ptca, \n"+
              "     @pvd, @dsma, \n"+
              "     @renal, @mets, \n"+
              "     @gld, \n"+
              "     @trig, @hba1c, @cvdr\n"+
              "\n"+
              "IF @@FETCH_STATUS = 0\n"+
              "BEGIN\n"+
              "  FETCH NEXT FROM cc \n"+
              "  INTO @age_n, @gen_n, @eth_n,\n"+
              "       @heig_n, @weig_n, @waist_n,\n"+
              "       @sbp_n, @sbpp_n,\n"+
              "       @dbp_n, @dbpp_n,\n"+
              "       @smok_n, @tchdl_n, \n"+
              "       @tc_n, @hdl_n,\n"+
              "       @diab_n, @yodd_n, @fhcvd_n, \n"+
              "       @tia_n, @angi_n, @ptca_n, \n"+
              "       @pvd_n, @dsma_n, \n"+
              "       @renal_n, @mets_n, \n"+
              "       @gld_n,\n"+
              "       @trig_n, @hba1c_n, @cvdr_n\n"+
              "  WHILE @@FETCH_STATUS = 0\n"+
              "  BEGIN\n"+
              "    -- Merge to get the latest value from what data we have !! \n"+
              "    IF ( @heig is null )\n"+
              "      SET @heig = @heig_n\n"+
              "    IF ( @weig is null )\n"+
              "      SET @weig = @weig_n\n"+
              "    IF ( @waist is null )\n"+
              "      SET @waist = @waist_n\n"+
              "    IF ( @sbp is null )\n"+
              "    BEGIN\n"+
              "      SET @sbp = @sbp_n\n"+
              "      SET @sbpp = @sbpp_n\n"+
              "    END\n"+
              "    ELSE\n"+
              "    BEGIN\n"+
              "      IF ( @sbpp is null )\n"+
              "        SET @sbpp = @sbp_n\n"+
              "    END\n"+
              "\n"+
              "    IF ( @dbp is null )\n"+
              "    BEGIN\n"+
              "      SET @dbp = @dbp_n\n"+
              "      SET @dbpp = @dbpp_n\n"+
              "    END\n"+
              "    ELSE\n"+
              "    BEGIN\n"+
              "      IF ( @dbpp is null )\n"+
              "        SET @dbpp = @dbp_n\n"+
              "    END\n"+
              "\n"+
              "    \n"+
              "    IF ( @smok is null )\n"+
              "      SET @smok = @smok_n\n"+
              "    IF ( @tchdl is null )\n"+
              "      SET @tchdl = @tchdl_n\n"+
              "    IF ( @tc is null )\n"+
              "      SET @tc = @tc_n\n"+
              "    IF ( @hdl is null )\n"+
              "      SET @hdl = @hdl_n\n"+
              "    IF ( @diab is null )\n"+
              "      SET @diab = @diab_n\n"+
              "    IF ( @tia is null )\n"+
              "      SET @tia = @tia_n\n"+
              "    IF ( @angi is null )\n"+
              "      SET @angi = @angi_n\n"+
              "    IF ( @ptca is null )\n"+
              "      SET @ptca = @ptca_n\n"+
              "    IF ( @pvd is null )\n"+
              "      SET @pvd = @pvd_n\n"+
              "    IF ( @dsma is null )\n"+
              "      SET @dsma = @dsma_n\n"+
              "    IF ( @renal is null )\n"+
              "      SET @renal = @renal_n\n"+
              "    IF ( @mets is null )\n"+
              "      SET @mets = @mets_n\n"+
              "    IF ( @gld is null )\n"+
              "      SET @gld = @gld_n\n"+
              "    IF ( @trig is null )\n"+
              "      SET @trig = @trig_n\n"+
              "    IF ( @hba1c is null )\n"+
              "      SET @hba1c = @hba1c_n\n"+
              "    IF ( @cvdr is null )\n"+
              "      SET @cvdr = @cvdr_n\n"+
              "      \n"+
              "    -- Get next row\n"+
              "    FETCH NEXT FROM cc \n"+
              "    INTO @age_n, @gen_n, @eth_n,\n"+
              "         @heig_n, @weig_n, @waist_n,\n"+
              "         @sbp_n, @sbpp_n,\n"+
              "         @dbp_n, @dbpp_n,\n"+
              "         @smok_n, @tchdl_n, \n"+
              "         @tc_n, @hdl_n,\n"+
              "         @diab_n, @yodd_n, @fhcvd_n, \n"+
              "         @tia_n, @angi_n, @ptca_n, \n"+
              "         @pvd_n, @dsma_n, \n"+
              "         @renal_n, @mets_n, \n"+
              "         @gld_n,\n"+
              "         @trig_n, @hba1c_n, @cvdr_n\n"+
              "      \n"+
              "  END\n"+
              "  -- Have some data, Calc missing values\n"+
              "  SET @result = ''\n"+
              "  SET @hits = 0\n"+
              "  SET @bmi = NULL\n"+
              "\n"+
              "  if ( @sbpp is null ) OR ( @sbpp < 10 )\n"+
              "    SET @sbpp = @sbp\n"+
              "  if ( @dbpp is null ) OR ( @dbpp < 10 )\n"+
              "    SET @dbpp = @dbp\n"+
              "  if ( @tchdl is null ) and ( @tc > 0.1 ) and ( @hdl > 0.1 )\n"+
              "    SET @tchdl = @tc / @hdl\n"+
              "  \n"+
              "  if ( @heig > 10 ) and ( @weig > 10 )\n"+
              "    SET @bmi = dbo.bmi(@weig,@heig)\n"+
              "  \n"+
              "  -- Work out health factors\n"+
              "  \n"+
              "  \n"+
              "  IF ((@sbp > 170 or @dbp > 100) and (@sbpp > 170 or @dbpp > 100))\n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'Hypertension. ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "      \n"+
              "  IF (@smok like 'yes%')\n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'Smoker. ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  IF (@diab like 'type%')\n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'Diabetes. ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  \n"+
              "  IF (@tia like 'yes%')\n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'Stroke/Tia. ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  IF (@angi like 'yes%')\n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'Angina/AMI. ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  IF (@ptca like 'yes%')\n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'PTCA/CABG. ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  IF (@pvd like 'yes%')\n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'PVD. ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  IF (@dsma like 'pos%') OR (@renal  like '%microalb%')\n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'Microalbuminuria. ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  IF (@renal  like 'nep%') OR (@renal  like 'yes%')\n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'Renal disease. ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  \n"+
              "  IF (@mets like 'yes%')\n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'Metabolic syndrome. ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  \n"+
              "  IF (@gld like 'famil%' ) OR (@gld like 'other%' ) OR (@gld like 'yes%' ) \n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'Genetic lipid disorder. ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  IF (@hba1c > 8.0) \n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'Risk of Hyperglycaemia (HbA1c > 8). ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  IF ((@tchdl > 8.0)  or (@tc > 8.0)) \n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'Risk of atherosclerosis (TC,TC/HTL > 8). ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  IF (@trig >= 10.0) \n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'Risk of a pancreatitis (Triglycerides  >= 10). ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  \n"+
              "  IF (@bmi >= 30) \n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'Query obesity (BMI). ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  \n"+
              "  SET @OBESE_WAIST = 90\n"+
              "  if ( @gen = 'M' )\n"+
              "    SET @OBESE_WAIST = 100\n"+
              "  \n"+
              "  IF ((@bmi < 30) OR ( @bmi is null)) AND ( @waist > @OBESE_WAIST )\n"+
              "  BEGIN\n"+
              "    SET @result = @result + 'Query obesity (Waist). ' \n"+
              "    SET @hits = @hits + 1\n"+
              "  END\n"+
              "  \n"+
              "  \n"+
              "  IF ( @cvdr >= 15 )\n"+
              "  BEGIN\n"+
              "     if ( @cvdr >= 35 )\n"+
              "       SET @result = @result + 'CVD Risk >= 35%. '\n"+
              "     ELSE\n"+
              "       SET @result = @result + 'CVD Risk >= 15%. '\n"+
              "    SET @hits = @hits + 2\n"+
              "  END\n"+
              "  \n"+
              "  \n"+
              "  If ( @cvdr is null )\n"+
              "  BEGIN\n"+
              "    SET @est_cvdr=dbo.calc_est_cvdr( @age, @gen, @eth, \n"+
              "               @sbp, @sbpp, @dbp, @dbpp,\n"+
              "               @smok, @tchdl, @tc, @hdl,\n"+
              "               @diab, @yodd, @fhcvd,  @tia,\n"+
              "               @angi, @ptca, @pvd, @dsma,\n"+
              "               @renal, @hba1c, @mets,\n"+
              "               @gld, @trig );    \n"+
              "    if ( @est_cvdr >= 15 )\n"+
              "    BEGIN\n"+
              "       if ( @est_cvdr >= 35 )\n"+
              "         SET @result = @result + 'CVD Risk (est) >= 35%. '\n"+
              "       ELSE\n"+
              "         SET @result = @result + 'CVD Risk (est) >= 15%. '\n"+
              "       SET @hits = @hits + 1\n"+
              "    END \n"+
              "  END\n"+
              "  \n"+
              "  IF ( @hits < 2 )\n"+
              "    SET @result = NULL\n"+
              "  \n"+
              "END\n"+
              "\n"+
              "CLOSE cc \n"+
              "DEALLOCATE cc\n"+
              "\n"+
              "RETURN @result  \n"+
              "END"
    
  end

  def self.down
  end
end
