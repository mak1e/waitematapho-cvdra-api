class CreateTreatmentAlertsFn < ActiveRecord::Migration
  def self.up
     execute  "CREATE FUNCTION treatment_alerts(@patient_id integer)\n"+
              "-- Generate any treatment alerts for this patient\n"+
              "-- Looks for last 18-months worth of data, Currently only applicable for Diabetes/CVD Data\n"+
              "RETURNS varchar(600)\n"+
              "AS\n"+
              "BEGIN\n"+
              "DECLARE @result varchar(600)\n"+
              "\n"+
              "DECLARE @systolic_blood_pressure  integer, @diastolic_blood_pressure integer\n"+
              "DECLARE @type_of_diabetes varchar(18), @hba1c decimal(8,2)\n"+
              "DECLARE @total_cholesterol decimal(8,2), @hdl_cholesterol decimal(8,2), @tc_hdl_ratio decimal(8,2)\n"+
              "DECLARE @insulin varchar(18), @lifestyle_therapy varchar(18)\n"+
              "DECLARE @cvd_risk decimal(8,2), @aspirin varchar(18) \n"+
              "DECLARE @statin varchar(18), @fibrate varchar(18), @other_lipid_lowering_medication varchar(18)     \n"+
              "DECLARE @urine_albumin_to_creatine_ratio decimal(8,2), @serum_creatinine decimal(8,2)\n"+
              "DECLARE @egfr_glumeral_filtration  decimal(8,2)\n"+
              "DECLARE @ace_inhibitor varchar(18), @a2_receptor_antagonist varchar(18)\n"+
              "DECLARE @dipstick_test_for_microalbuminuria  varchar(18), @established_renal_disease varchar(18) \n"+
              "\n"+
              "DECLARE @age_n integer, @gender_id_n varchar(1), @ethnicity_id_n integer \n"+
              "DECLARE @systolic_blood_pressure_n  integer, @diastolic_blood_pressure_n integer\n"+
              "DECLARE @type_of_diabetes_n varchar(18), @hba1c_n decimal(8,2)\n"+
              "DECLARE @total_cholesterol_n decimal(8,2), @hdl_cholesterol_n decimal(8,2), @tc_hdl_ratio_n decimal(8,2)\n"+
              "DECLARE @insulin_n varchar(18), @lifestyle_therapy_n varchar(18)\n"+
              "DECLARE @cvd_risk_n decimal(8,2), @aspirin_n varchar(18) \n"+
              "DECLARE @statin_n varchar(18), @fibrate_n varchar(18), @other_lipid_lowering_medication_n varchar(18)     \n"+
              "DECLARE @urine_albumin_to_creatine_ratio_n decimal(8,2), @serum_creatinine_n decimal(8,2)\n"+
              "DECLARE @egfr_glumeral_filtration_n  decimal(8,2)\n"+
              "DECLARE @ace_inhibitor_n varchar(18), @a2_receptor_antagonist_n varchar(18)\n"+
              "DECLARE @dipstick_test_for_microalbuminuria_n varchar(18), @established_renal_disease_n varchar(18) \n"+
              "\n"+
              "\n"+
              "DECLARE cc CURSOR LOCAL FOR \n"+
              "select d.sbp_systolic_blood_pressure, d.dbp_diastolic_blood_pressure,\n"+
              "       LOWER(d.diab_type_of_diabetes),d.hba1c_hba1c,\n"+
              "       d.tc_total_cholesterol, d.hdl_hdl_cholesterol, d.tchdl_tc_hdl_ratio,\n"+
              "       LOWER(d.insu_insulin), LOWER(lifet_lifestyle_therapy),\n"+
              "       cvdr_cvd_risk, LOWER(aspi_aspirin),\n"+
              "       LOWER(statin_statin), LOWER(fibra_fibrate), LOWER(ollm_other_lipid_lowering_medication),\n"+
              "       acr_urine_albumin_to_creatine_ratio,creat_serum_creatinine,\n"+
              "       egfr_glumeral_filtration,\n"+
              "       LOWER(acei_ace_inhibitor), LOWER(a2ra_a2_receptor_antagonist),\n"+
              "       LOWER(dsma_dipstick_test_for_microalbuminuria), LOWER(renal_established_renal_disease)\n"+
              "       \n"+
              "from claims c \n"+
              "  left join claims_data d on d.id = c.id \n"+
              "where c.patient_id = @patient_id and c.invoice_date < DateAdd(mm,-18,GetDate())\n"+
              "order by c.invoice_date desc\n"+
              "FOR READ ONLY; \n"+
              "       \n"+
              "SET @result = ''\n"+
              "\n"+
              "OPEN cc\n"+
              "FETCH NEXT FROM cc \n"+
              "INTO \n"+
              "  @systolic_blood_pressure, @diastolic_blood_pressure,\n"+
              "  @type_of_diabetes, @hba1c,\n"+
              "  @total_cholesterol, @hdl_cholesterol, @tc_hdl_ratio,\n"+
              "  @insulin, @lifestyle_therapy,\n"+
              "  @cvd_risk, @aspirin,\n"+
              "  @statin, @fibrate, @other_lipid_lowering_medication,\n"+
              "  @urine_albumin_to_creatine_ratio,@serum_creatinine,\n"+
              "  @egfr_glumeral_filtration,\n"+
              "  @ace_inhibitor,@a2_receptor_antagonist,\n"+
              "  @dipstick_test_for_microalbuminuria, @established_renal_disease\n"+
              "  \n"+
              "\n"+
              "IF @@FETCH_STATUS = 0\n"+
              "BEGIN\n"+
              "  FETCH NEXT FROM cc \n"+
              "  INTO\n"+
              "    @systolic_blood_pressure_n, @diastolic_blood_pressure_n,\n"+
              "    @type_of_diabetes_n, @hba1c_n,\n"+
              "    @total_cholesterol_n, @hdl_cholesterol_n, @tc_hdl_ratio_n,\n"+
              "    @insulin_n, @lifestyle_therapy_n,\n"+
              "    @cvd_risk_n, @aspirin_n,\n"+
              "    @statin_n, @fibrate_n, @other_lipid_lowering_medication_n,\n"+
              "    @urine_albumin_to_creatine_ratio_n,@serum_creatinine_n,\n"+
              "    @egfr_glumeral_filtration_n,\n"+
              "    @ace_inhibitor_n,@a2_receptor_antagonist_n,\n"+
              "    @dipstick_test_for_microalbuminuria_n, @established_renal_disease_n\n"+
              "       \n"+
              "  WHILE @@FETCH_STATUS = 0\n"+
              "  BEGIN\n"+
              "    -- Merge to get the latest value from what data we have !! \n"+
              "    IF ( @systolic_blood_pressure is null ) SET @systolic_blood_pressure = @systolic_blood_pressure_n\n"+
              "    IF ( @diastolic_blood_pressure is null ) SET @diastolic_blood_pressure = @diastolic_blood_pressure_n\n"+
              "    IF ( @type_of_diabetes is null ) SET @type_of_diabetes = @type_of_diabetes_n\n"+
              "    IF ( @hba1c is null ) SET @hba1c = @hba1c_n\n"+
              "    IF ( @total_cholesterol is null ) SET @total_cholesterol = @total_cholesterol_n\n"+
              "    IF ( @hdl_cholesterol is null ) SET @hdl_cholesterol = @hdl_cholesterol_n\n"+
              "    IF ( @tc_hdl_ratio is null ) SET @tc_hdl_ratio = @tc_hdl_ratio_n\n"+
              "    IF ( @insulin is null ) SET @insulin = @insulin_n\n"+
              "    IF ( @lifestyle_therapy is null ) SET @lifestyle_therapy = @lifestyle_therapy_n\n"+
              "    IF ( @cvd_risk is null ) SET @cvd_risk = @cvd_risk_n\n"+
              "    IF ( @aspirin is null ) SET @aspirin = @aspirin_n\n"+
              "    IF ( @statin is null ) SET @statin = @statin_n\n"+
              "    IF ( @other_lipid_lowering_medication is null ) SET @other_lipid_lowering_medication = @other_lipid_lowering_medication_n\n"+
              "    IF ( @urine_albumin_to_creatine_ratio is null ) SET @urine_albumin_to_creatine_ratio = @urine_albumin_to_creatine_ratio_n\n"+
              "    IF ( @serum_creatinine is null ) SET @serum_creatinine = @serum_creatinine_n\n"+
              "    IF ( @egfr_glumeral_filtration is null ) SET @egfr_glumeral_filtration = @egfr_glumeral_filtration_n\n"+
              "    IF ( @ace_inhibitor is null ) SET @ace_inhibitor = @ace_inhibitor_n\n"+
              "    IF ( @a2_receptor_antagonist is null ) SET @a2_receptor_antagonist = @a2_receptor_antagonist_n\n"+
              "    IF ( @dipstick_test_for_microalbuminuria is null ) SET @dipstick_test_for_microalbuminuria = @dipstick_test_for_microalbuminuria_n\n"+
              "    IF ( @established_renal_disease is null ) SET @established_renal_disease = @established_renal_disease_n\n"+
              "\n"+
              "    -- Get next row\n"+
              "    FETCH NEXT FROM cc \n"+
              "    INTO\n"+
              "      @systolic_blood_pressure_n, @diastolic_blood_pressure_n,\n"+
              "      @type_of_diabetes_n, @hba1c_n,\n"+
              "      @total_cholesterol_n, @hdl_cholesterol_n, @tc_hdl_ratio_n,\n"+
              "      @insulin_n, @lifestyle_therapy_n,\n"+
              "      @cvd_risk_n, @aspirin_n,\n"+
              "      @statin_n, @fibrate_n, @other_lipid_lowering_medication_n,\n"+
              "      @urine_albumin_to_creatine_ratio_n,@serum_creatinine_n,\n"+
              "      @egfr_glumeral_filtration_n,\n"+
              "      @ace_inhibitor_n,@a2_receptor_antagonist_n,\n"+
              "      @dipstick_test_for_microalbuminuria_n, @established_renal_disease_n\n"+
              "        \n"+
              "  END\n"+
              "\n"+
              "  -- Data items must have, to recommend starting treatment -- Must of said y/n otherwise dont know/can't advise\n"+
              "  IF ( @aspirin = ''  )  SET @aspirin = NULL\n"+
              "  IF ( @insulin = ''  )  SET @insulin = NULL\n"+
              "  IF ( @statin = '' )  SET @statin  = NULL\n"+
              "  IF ( @ace_inhibitor = '' )  SET @ace_inhibitor = NULL\n"+
              "  \n"+
              "  -- Optional data items, Assume NO if blank/not specified\n"+
              "  IF ( @aspirin is null )  SET @aspirin = ''\n"+
              "  IF ( @fibrate is null )  SET @fibrate = ''\n"+
              "  IF ( @other_lipid_lowering_medication is null )  SET @other_lipid_lowering_medication = ''\n"+
              "  IF ( @a2_receptor_antagonist is null )  SET @a2_receptor_antagonist = ''\n"+
              "  \n"+
              "  -- Do some calculations\n"+
              "  if ( @tc_hdl_ratio is null ) and ( @total_cholesterol > 0.1 ) and ( @hdl_cholesterol > 0.1 )\n"+
              "     SET @tc_hdl_ratio = @total_cholesterol / @hdl_cholesterol\n"+
              "  \n"+
              "  -- Calculate alters\n"+
              "  IF (( @systolic_blood_pressure >= 140 ) and ( @diastolic_blood_pressure >= 90 ) and ( @type_of_diabetes like 'type%' ))\n"+
              "    SET @result = @result + 'Diabetic, BP >= 140/90, review anti-hypertensive treatment. '\n"+
              "\n"+
              "  IF (( @hba1c >= 9.0 ) and  ( @type_of_diabetes like 'type 2%' ) and ( @insulin not like 'y%' ))\n"+
              "    SET @result = @result + 'Type 2 diabetes, HbA1c (' + cast(@hba1c as varchar(8)) + ') >= 9.0, review oral medications/compliance, consider insulin. '\n"+
              "\n"+
              "  IF (( @hba1c > 8.0 ) and  ( @type_of_diabetes like 'type%' ) and  ( @statin not like 'y%' ) and  ( @fibrate not like 'y%' ) and  ( @other_lipid_lowering_medication not like 'y%' ))\n"+
              "    SET @result = @result + 'Diabetic, HbA1c (' + cast(@hba1c as varchar(8)) + ') > 8.0, consider a statin. '\n"+
              "\n"+
              "  IF (( @cvd_risk >= 15 ) and  ( @statin not like 'y%' ) and  ( @fibrate not like 'y%' ) and  ( @other_lipid_lowering_medication not like 'y%' ))\n"+
              "     SET @result = @result + 'CVD Risk >= 15, consider a statin. '\n"+
              "\n"+
              "  IF (( @tc_hdl_ratio > 5 ) and  ( @statin not like 'y%' ) and  ( @fibrate not like 'y%' ) and  ( @other_lipid_lowering_medication not like 'y%' ))\n"+
              "     SET @result = @result + 'TC/HDL >= 5, consider a statin. '\n"+
              "     \n"+
              "    \n"+
              "  IF (( @urine_albumin_to_creatine_ratio > 30 ) and  ( @ace_inhibitor not like 'y%' ) and  ( @a2_receptor_antagonist not like 'y%' ))\n"+
              "    SET @result = @result + 'Albumin Creatine Ratio (' + cast(@urine_albumin_to_creatine_ratio as varchar(8)) + ') > 30, consider ACE inhibitor / A2 receptor-antagonist. ' \n"+
              "\n"+
              "  IF ( ( @serum_creatinine < 0.50 ) and ( @serum_creatinine > 0.15 ) and  ( @ace_inhibitor not like 'y%' ) and  ( @a2_receptor_antagonist not like 'y%' ))\n"+
              "    SET @result = @result + 'Serum Creatine (' + cast(@serum_creatinine as varchar(8)) + ') > 0.150 mmol/L, consider ACE inhibitor / A2 receptor-antagonist. '\n"+
              "     \n"+
              "  IF (( @serum_creatinine > 150 ) and  ( @ace_inhibitor not like 'y%' ) and  ( @a2_receptor_antagonist not like 'y%' ))\n"+
              "    SET @result = @result + 'Serum Creatine (' + cast(@serum_creatinine as varchar(8)) + ') > 150 umol/L, consider ACE inhibitor / A2 receptor-antagonist. ' \n"+
              "\n"+
              "  IF (( @established_renal_disease like '%microalbumin%' ) and  ( @ace_inhibitor not like 'y%' ) and  ( @a2_receptor_antagonist not like 'y%' ))\n"+
              "    SET @result = @result + 'Confirmed microalbuminuria, consider ACE inhibitor / A2 receptor-antagonist. ' \n"+
              "\n"+
              "  IF ( (@result <> '' ) and ( @cvd_risk >= 15 ) and  ( @aspirin not like 'y%' )) -- Only show asprin if other things as well\n"+
              "    SET @result = @result + 'CVD Risk >= 15%, consider low dose aspirin. '\n"+
              "\n"+
              "END\n"+
              "\n"+
              "CLOSE cc \n"+
              "DEALLOCATE cc\n"+
              "\n"+
              "RETURN @result  \n"+
              "END     \n"
     
  end

  def self.down
    execute "DROP FUNCTION treatment_alerts"
  end
end
