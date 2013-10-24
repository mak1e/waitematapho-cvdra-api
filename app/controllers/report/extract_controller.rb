class Report::ExtractController < Report::BaseController
  
  NHI_ENCRYPT_SECRET_KEY = '8a53fb2801cb0bc1'
  
  require 'faster_csv'
  
  def criteria
    # Need an object, So can set the defaults on the date 
    @criteria = Criteria.new
    @criteria.start_date = Date.today.at_beginning_of_month.last_month
    @criteria.end_date = @criteria.start_date.end_of_month
    @criteria.start_date = @criteria.start_date.months_since( -2 )    # Default to a Qtr
    
    @criteria.pho_id = Registry.read_string('extract','pho_id','000000')
    
    
#    # For testing
#    @criteria.programme_id = Programme::CVDR
#    @criteria.end_date = @criteria.end_date.next_month
    
  end 
  
  
  def run
    @criteria = Criteria.new(params[:criteria]);
    @criteria.start_date = @criteria.start_date.at_beginning_of_month
    @criteria.end_date = @criteria.end_date.end_of_month
    
    Registry.write_string('extract','pho_id',@criteria.pho_id);
    
    if params[:extract_type] == 'encrypted_nhi'
      if ( @criteria.programme_id != Programme::DIAB ) 
         flash[:alert] = 'NHI download is for Diabetes only'
         render :action => 'criteria'
         return
      end
      encrypted_nhi_download
    elsif params[:extract_type] == 'cvdxml_data_extract'
      if ( @criteria.programme_id != Programme::CVDR ) 
         flash[:alert] = 'CVDR download is for CVDR only'
         render :action => 'criteria'
         return
      end
      cvdxml_data_extract
    else
        render :text => "No Criteria", :status => 200
    end
  end
  

  def encrypted_nhi_download
    query = Query.find_by_sql([
          "select distinct p.nhi_no\n"+
          "from claims c\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and p.nhi_no is not null\n"+
          "order by 1\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])

    tmp_txt = File.join(RAILS_ROOT,'tmp',"enhi.txt")
    File.unlink(tmp_txt) if File.exists?(tmp_txt)

    File.open(tmp_txt, "w") do |txt|
       query.each do |e|
         txt.puts Digest::MD5.hexdigest( e.nhi_no + NHI_ENCRYPT_SECRET_KEY ) 
       end
    end
    
    send_file(tmp_txt,:type => 'text/plain', :filename => "PHO-#{@criteria.pho_id}-ENHI-#{@criteria.start_date.to_s(:db)[0,7]}-#{@criteria.end_date.to_s(:db)[0,7]}.txt" )
    
end

  # <?xml version="1.0" encoding="UTF-8"?>
  # <Message xmlns="nz:govt:moh:schemas:diabetes-cardio-simplified" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  # <Record>
  #   <PHOID>610735</PHOID>
  #   <TransactionID>78bf44b20f11f461</TransactionID>
  # <PatientIdentification>
  #   <PatientExternalID>c14e73436f89dad0356a9a38e090a3f8</PatientExternalID>
  #   <DateOfBirth>1987-12-28</DateOfBirth>
  #   <Gender>M</Gender>
  #   <PHORegistrationStatus>E</PHORegistrationStatus>
  #   <PrioritisedEthnicity>11</PrioritisedEthnicity>
  #   <DeprivationQuintile xsi:nil="true"/>
  #   <GetCheckedEnrolmentStatus xsi:nil="true"/>
  # </PatientIdentification>
  # <ClinicalDataCardiovascular>
  #   <DateOfReview>2008-05-01</DateOfReview>
  #   <SmokingHistory>3</SmokingHistory>
  #   <TypeOfDiabetes>1</TypeOfDiabetes>
  #   <Angina-AMI>0</Angina-AMI>
  #   <PeripheralVesselDisease>0</PeripheralVesselDisease>
  #   <GeneticLipidDisorder>0</GeneticLipidDisorder>
  #   <AtrialFibrillation>0</AtrialFibrillation>
  #   <DiagnosedMetabolicSyndrome>0</DiagnosedMetabolicSyndrome>
  #   <SystolicBloodPressureToday>118</SystolicBloodPressureToday>
  #   <DiastolicBloodPressureToday>70</DiastolicBloodPressureToday>
  #   <SystolicBloodPressurePrevious>118</SystolicBloodPressurePrevious>
  #   <DiastolicBloodPressurePrevious>70</DiastolicBloodPressurePrevious>
  #   <TotalCholesterol>5</TotalCholesterol>
  #   <CardioVascularRiskAssessment>3</CardioVascularRiskAssessment>
  # </ClinicalDataCardiovascular>
  # 

  #   <HbA1c>9</HbA1c>
  # </ClinicalDataDiabetes>
  # </Record> 
  # </Message>
  # 
  def cvdxml_data_extract
    cvdrs = Claim.find(:all,
             :conditions => ["date_service >= ?  and date_service <= ? \n"+
                             "and programme_id = ?\n"+
                             "and claim_status_id <= 6\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
           
    tmp_xml = File.join(RAILS_ROOT,'tmp',"cvdr.xml")
    File.unlink(tmp_xml) if File.exists?(tmp_xml)
    File.open(tmp_xml, "w") do |xml|
      xml.puts '<?xml version="1.0" encoding="UTF-8"?>'
      xml.puts '<Message xmlns="nz:govt:moh:schemas:diabetes-cardio-simplified" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'      
      cvdrs.each do |c|
        xml.puts '<Record>'
        xml.puts "<PHOID>#{@criteria.pho_id}</PHOID>"
        xml.puts "<TransactionID>#{c.id}</TransactionID>"
        xml.puts '<PatientIdentification>'
        
        xml.puts Report::ExtractController.xml_value('PatientExternalID', Digest::MD5.hexdigest( c.patient.nhi_no.to_s + NHI_ENCRYPT_SECRET_KEY ), 's')
        c.patient.date_of_birth = Date.new(2000,1,1) if c.patient.date_of_birth.blank?
        xml.puts Report::ExtractController.xml_value('DateOfBirth', c.patient.date_of_birth, 'd')
        c.patient.gender_id = 'M' if c.patient.gender_id.blank?        
        xml.puts Report::ExtractController.xml_value('Gender', c.patient.gender_id, 's')
        xml.puts Report::ExtractController.xml_value('PHORegistrationStatus', 'E', 's')
        c.patient.ethnicity_id = 99 if c.patient.ethnicity_id.blank?
        xml.puts Report::ExtractController.xml_value('PrioritisedEthnicity', c.patient.ethnicity_id.to_s, 's')
        xml.puts Report::ExtractController.xml_value_nil('DeprivationQuintile', c.patient.quintile.to_s, 's')
        xml.puts Report::ExtractController.xml_value_nil('GetCheckedEnrolmentStatus', '', 's')
        xml.puts '</PatientIdentification>'
        
        # ===============================================
        xml.puts '<ClinicalDataCardiovascular>'
        xml.puts Report::ExtractController.xml_value('DateOfReview', c.date_service, 'd')
        xml.puts Report::ExtractController.xml_value('Height', c.data.heig_height, 'i')
        xml.puts Report::ExtractController.xml_value('Weight', c.data.weig_weight, 'i')
        xml.puts Report::ExtractController.xml_value('WaistCircumference', c.data.waist_waist_circumference, 'i')
        
        # smok_smoking_history|No|Past|Yes|Yes - up to 10 / d|Ex|Yes - 11-19 / day|Yes - 20+ / day|Recently quit|Yes - up to 10 / day|Passive
        # 0 = No - never (defau|1 = No - quit over 12|2 = No - quit within 12|3 = Yes - up to 10 / d|4 = Yes - 10-19 / day|5 = Yes - 20+ / day 
        xml.puts Report::ExtractController.xml_value('SmokingHistory', c.data.smok_smoking_history, 's',
           [ { :match => /no/i, :mapto => '0'}, 
             { :match => /ex/i, :mapto => '1'}, 
             { :match => /past/i, :mapto => '1'}, 
             { :match => /recent/i, :mapto => '2'},
             { :match => /recient/i, :mapto => '2'},
             { :match => /up to 10/i, :mapto => '3'}, 
             { :match => /11/i, :mapto => '4'}, 
             { :match => /20+/i, :mapto => '5'}, 
             { :match => /yes/i, :mapto => '3'}
           ])
        
        # diab_type_of_diabetes|No diabetes|Type 2|Type 1|Type unknown|Other known type|Gestational
        # 0 = No diabetes|1 = Type 1|2 = Type 2|3 = Type unknown|4 = Gestational|6 = Other known type|7 = IGT / IFG|9 = Diabetes status unknown 
        xml.puts Report::ExtractController.xml_value('TypeOfDiabetes', c.data.diab_type_of_diabetes, 's',
           [ { :match => /no diab/i, :mapto => '0'}, 
             { :match => /type 1/i, :mapto => '1'}, 
             { :match => /type 2/i, :mapto => '2'}, 
             { :match => /unknown/i, :mapto => '3'}, 
             { :match => /gest/i, :mapto => '4'}, 
             { :match => /other/i, :mapto => '6'}, 
             { :match => /igt/i, :mapto => '7'}, 
             { :match => /ifg/i, :mapto => '7'}
           ])
           
         map_no_yes = [ { :match => /no/i, :mapto => '0'}, 
                        { :match => /yes/i, :mapto => '1'}  ]
         
        
        # hoac_history_of_acute_coronary_syndrome|0=No|1=Yes
        xml.puts Report::ExtractController.xml_value('HistoryOfAcuteCoronarySyndrome', c.data.hoac_history_of_acute_coronary_syndrome, 's',map_no_yes)
        
        
        # angi_angina_ami|0=No|1=Yes
        xml.puts Report::ExtractController.xml_value('Angina-AMI', c.data.angi_angina_ami, 's',map_no_yes)
        
        # ptca_ptca_cabg|0=No|1=Yes
        xml.puts Report::ExtractController.xml_value('PTCA-CABG', c.data.ptca_ptca_cabg, 's',map_no_yes)
        
        # tia_stroke_tia|0=No|1=Yes
        xml.puts Report::ExtractController.xml_value('Stroke-TIA', c.data.tia_stroke_tia, 's',map_no_yes)
        
        # pvd_peripheral_vessel_disease|0=No|1=Yes
        xml.puts Report::ExtractController.xml_value('PeripheralVesselDisease', c.data.pvd_peripheral_vessel_disease, 's',map_no_yes)
        
        # fhcvd_family_history_early_cardiovascular_disease|0=No|1=Yes
        xml.puts Report::ExtractController.xml_value('FamilyHistoryEarlyCardiovascularDisease', c.data.fhcvd_family_history_early_cardiovascular_disease, 's' ,map_no_yes)
        
        # gld_genetic_lipid_disorder|Familial hyperchol|Other genetic lipi|Familial hypercholestrolaemia|
        # Familial combined|Other genetic lipid disorder|Familial combined hypercholesterolaemia|
        # None|No|Familial defective|Familial defective apoB
        # 0 = None (default) |1 = Familial hypercholestrolaemia|2 = Familial defective apoB|3 = Familial combined hypercholesterolaemia |4 = Other genetic lipid disorder
        xml.puts Report::ExtractController.xml_value('GeneticLipidDisorder', c.data.gld_genetic_lipid_disorder, 's',
           [ { :match => /no/i, :mapto => '0'}, 
             { :match => /none/i, :mapto => '0'}, 
             { :match => /familial hyper/i, :mapto => '1'},
             { :match => /familial defec/i, :mapto => '2'},
             { :match => /combined/i, :mapto => '3'},
             { :match => /other/i, :mapto => '4'}
           ])
        
        # renal_established_renal_disease|Confirmed microalb|Overt diabetic nep|Non diabetic nephr
        # 0 = No nephropathy|1 = Confirmed microalbuminuria|2 = Overt diabetic nephropathy|
        # 3 = Non diabetic nephropathy|9 = Not established / not known (default)        
        xml.puts Report::ExtractController.xml_value('EstablishedRenalDisease', c.data.renal_established_renal_disease, 's',
           [ { :match => /no neph/i, :mapto => '0'},
             { :match => /confirmed micro/i, :mapto => '1'}, 
             { :match => /overt diabetic/i, :mapto => '2'}, 
             { :match => /non diab/i, :mapto => '3'},
             { :match => /combined/i, :mapto => '3'},
             { :match => /other/i, :mapto => '4'}
           ])
                
        # atfi_atrial_fibrillation|0=No|1=Yes
        xml.puts Report::ExtractController.xml_value( 'AtrialFibrillation', c.data.atfi_atrial_fibrillation, 's',map_no_yes)
        
        # mets_diagnosed_metabolic_syndrome|0=No|1=Yes
        xml.puts Report::ExtractController.xml_value( 'DiagnosedMetabolicSyndrome', c.data.mets_diagnosed_metabolic_syndrome, 's',map_no_yes)
        
        # xml.puts Report::ExtractController.xml_value( 'Pregnant', c.data.preg_pregnant, 's' # NO DATA
        
        xml.puts Report::ExtractController.xml_value( 'SystolicBloodPressureToday', c.data.sbp_systolic_blood_pressure, 'i')
        xml.puts Report::ExtractController.xml_value( 'DiastolicBloodPressureToday', c.data.dbp_diastolic_blood_pressure, 'i')
        xml.puts Report::ExtractController.xml_value( 'SystolicBloodPressurePrevious', c.data.sbpp_systolic_blood_pressure_previous, 'i')
        xml.puts Report::ExtractController.xml_value( 'DiastolicBloodPressurePrevious', c.data.dbpp_diastolic_blood_pressure_previous, 'i')
        
        xml.puts Report::ExtractController.xml_value( 'FastingGlucose', c.data.gluc_fasting_glucose, 'i')
        # xml.puts Report::ExtractController.xml_value( 'FastingGlucoseDate', c.data.xx, 's'
        xml.puts Report::ExtractController.xml_value( 'TotalCholesterol', c.data.tc_total_cholesterol, 'i')
        # xml.puts Report::ExtractController.xml_value( 'TotalCholesterolDate', c.data.xx, 's'
        xml.puts Report::ExtractController.xml_value( 'HDLCholesterol', c.data.hdl_hdl_cholesterol, 'i')
        xml.puts Report::ExtractController.xml_value( 'Triglyceride', c.data.trig_triglyceride, 'i')
        xml.puts Report::ExtractController.xml_value( 'SerumCreatinine', c.data.creat_serum_creatinine, 'i')
        # xml.puts Report::ExtractController.xml_value( 'SerumCreatinineDate', c.data.xx, 's'
        xml.puts Report::ExtractController.xml_value( 'eGFR', c.data.egfr_glumeral_filtration, 'i')
        xml.puts Report::ExtractController.xml_value( 'UrineAlbuminToCreatineRatio', c.data.acr_urine_albumin_to_creatine_ratio, 'i')

        # xml.puts Report::ExtractController.xml_value( 'UrineACRDate', c.data.xx, 's'
        
        # dsma_dipstick_test_for_microalbuminuria|Not done|Unknown|Negative|Not applicable|Positive
        # 0=Negative|1=Positive|2=Not Done 
        xml.puts Report::ExtractController.xml_value( 'DipstickTestForMicroalbuminuria', c.data.dsma_dipstick_test_for_microalbuminuria, 's',
           [ { :match => /neg/i, :mapto => '0'}, 
             { :match => /pos/i, :mapto => '1'},
             { :match => /not/i, :mapto => '2'}
           ])
        
        
        # xml.puts Report::ExtractController.xml_value( 'AlbuminProteinStickTest', c.data.apst_albumin_protein_stick_test, 's' # no data
        
        map_no_contra_yes =  [ { :match => /^no/i, :mapto => '0'}, 
                               { :match => /contra/i, :mapto => '1'},
                               { :match => /decl/i, :mapto => '1'},
                               { :match => /yes/i, :mapto => '2'}   ]
        
        
        # aspi_aspirin|0=No|1=Contra-indicated|3=Yes|Declined|
        xml.puts Report::ExtractController.xml_value( 'Aspirin', c.data.aspi_aspirin, 's',map_no_contra_yes)
          
        
        # clop_clopidogrel|0=No|1=Contra-indicated|3=Yes|Declined|
        xml.puts Report::ExtractController.xml_value( 'Clopidogrel', c.data.clop_clopidogrel, 's',map_no_contra_yes)
        
        # warf_warfarin|0=No|1=Contra-indicated|3=Yes|Declined|
        xml.puts Report::ExtractController.xml_value( 'Warfarin', c.data.warf_warfarin, 's',map_no_contra_yes)
        
        # acei_ace_inhibitor|0=No|1=Contra-indicated|3=Yes
        xml.puts Report::ExtractController.xml_value( 'ACEInhibitor', c.data.acei_ace_inhibitor, 's',map_no_contra_yes)
        
        # a2ra_a2_receptor_antagonist|0=No|1=Contra-indicated|3=Yes
        xml.puts Report::ExtractController.xml_value( 'A2ReceptorAntagonist', c.data.a2ra_a2_receptor_antagonist, 's',map_no_contra_yes)
        
        # beta_beta_blocker|0=No|1=Contra-indicated|3=Yes
        xml.puts Report::ExtractController.xml_value( 'BetaBlocker', c.data.beta_beta_blocker, 's',map_no_contra_yes)
        
        # thia_thiazide|0=No|1=Contra-indicated|3=Yes
        xml.puts Report::ExtractController.xml_value( 'Thiazide', c.data.thia_thiazide, 's',map_no_contra_yes)
        
        # caan_calcium_antagonist|0=No|1=Contra-indicated|3=Yes
        xml.puts Report::ExtractController.xml_value( 'CalciumAntagonist', c.data.caan_calcium_antagonist, 's',map_no_contra_yes)
        
        # oahm_other_anti_hypertensive_medication|0=No|1=Contra-indicated|3=Yes
        xml.puts Report::ExtractController.xml_value( 'OtherAntiHypertensiveMedication', c.data.oahm_other_anti_hypertensive_medication, 's',map_no_contra_yes)
        
        # statin_statin|0=No|1=Contra-indicated|3=Yes
        xml.puts Report::ExtractController.xml_value( 'Statin', c.data.statin_statin, 's',map_no_contra_yes)
        
        # fibra_fibrate|0=No|1=Contra-indicated|3=Yes
        xml.puts Report::ExtractController.xml_value( 'Fibrate', c.data.fibra_fibrate, 's',map_no_contra_yes)
        
        # ollm_other_lipid_lowering_medication|0=No|1=Contra-indicated|3=Yes
        xml.puts Report::ExtractController.xml_value( 'OtherLipidLoweringMedication', c.data.ollm_other_lipid_lowering_medication, 's',map_no_contra_yes)
        
        # nirt_nicotine_replacement_therapy|Yes|No
        # 0 = Never Offered|4 = Prescribed today
        xml.puts Report::ExtractController.xml_value( 'NicotineReplacementTherapy', c.data.nirt_nicotine_replacement_therapy, 's',
          [ { :match => /no/i, :mapto => '0'}, 
            { :match => /yes/i, :mapto => '4'}
           ]        )
        
        # green_green_prescription|Yes|No
        # 0 = Never Offered.|2 = Prescribed today 
        xml.puts Report::ExtractController.xml_value( 'GreenPrescription', c.data.green_green_prescription, 's',
          [ { :match => /no/i, :mapto => '0'}, 
            { :match => /yes/i, :mapto => '2'}
           ] )
        
        
        xml.puts Report::ExtractController.xml_value( 'CardioVascularRiskAssessment', c.data.cvdr_cvd_risk.to_i, 's')
        
        xml.puts '</ClinicalDataCardiovascular>'
        # ===============================================
        xml.puts '<ClinicalDataDiabetes>'
        
        xml.puts Report::ExtractController.xml_value( 'YearOfDiabetesDiagnosis', c.data.yodd_year_of_diabetes_diagnosis, 's')
        xml.puts Report::ExtractController.xml_value( 'HbA1c', c.data.hba1c_hba1c, 'i')
        # xml.puts Report::ExtractController.xml_value( 'HbA1cDate', c.data.xxx, 's'
        xml.puts Report::ExtractController.xml_value( 'DateLastRetinalScreening', c.data.retind_date_last_retinal_screening, 'd')
        # xml.puts Report::ExtractController.xml_value( 'RetinalScreeningInterval', c.data.xxx, 's' # No DATA
        
        # eyer_eye_referral_today|0 = No|3 = Yes to retinal screening programme
        xml.puts Report::ExtractController.xml_value( 'EyeReferralToday', c.data.eyer_eye_referral_today, 's',
          [ { :match => /no/i, :mapto => '0'}, 
            { :match => /yes/i, :mapto => '3'}
           ])
        
        xml.puts Report::ExtractController.xml_value( 'VisualAcuityLeft', c.data.vacl_visual_acuity_left, 's')
        xml.puts Report::ExtractController.xml_value( 'VisualAcuityRight', c.data.vacr_visual_acuity_right, 's')
        # xml.puts Report::ExtractController.xml_value( 'RetinopathyWorstEye', c.data.xxx, 's')
        # xml.puts Report::ExtractController.xml_value( 'MaculopathyWorstEye', c.data.xxx, 's')
        
        map_not_normal_abnormal = 
          [ { :match => /not/i, :mapto => '0'}, 
            { :match => /abnormal/i, :mapto => '4'},
            { :match => /norm/i, :mapto => '1'},
            { :match => /decl/i, :mapto => '0'},
           ]        
        
        # feets_feet_sensation|Normal|Abnormal|Not Examined
        # 0=Not examined|1=Normal|4=Abnormal (BOTH) 
        xml.puts Report::ExtractController.xml_value( 'FeetSensation', c.data.feets_feet_sensation, 's', map_not_normal_abnormal)
        
        # feetc_feet_circulation|Normal|Abnormal|Not Examined
        # 0=Not examined|1=Normal|4=Abnormal (BOTH) 
        xml.puts Report::ExtractController.xml_value( 'FeetCirculation', c.data.feetc_feet_circulation, 's',map_not_normal_abnormal)
        
        # xml.puts Report::ExtractController.xml_value( 'HistoryDiabeticFootUlcer', c.data.xxx, 's'
        # xml.puts Report::ExtractController.xml_value( 'CurrentDiabeticFootUlcer', c.data.xxx, 's'
        # xml.puts Report::ExtractController.xml_value( 'OtherCriteriaForHighRiskFoot', c.data.xxx, 's'
        # xml.puts Report::ExtractController.xml_value( 'PreviousDiabeticLowerLimbAmputation', c.data.xxx, 's'
        
        # lifet_lifestyle_therapy|1=Yes|0=No
        xml.puts Report::ExtractController.xml_value( 'DietLifestyleTherapyOnly', c.data.lifet_lifestyle_therapy, 's',map_no_yes)
        
        # xml.puts Report::ExtractController.xml_value( 'HypoglycaemicAttacks', c.data.xxx, 's' # NO DATA
        # xml.puts Report::ExtractController.xml_value( 'BloodGlucoseSelfMonitoring', c.data.xxx, 's' # NO DATA
        
        # insu_insulin|Yes|No
        # 0 = No (default),1 = Nocturnal only
        xml.puts Report::ExtractController.xml_value( 'Insulin', c.data.insu_insulin, 's', map_no_yes)

        map_no_contra_max_yes =  [ { :match => /^no/i, :mapto => '0'}, 
                                   { :match => /contra/i, :mapto => '1'},
                                   { :match => /decl/i, :mapto => '1'},
                                   { :match => /max/i, :mapto => '2'},
                                   { :match => /yes/i, :mapto => '3'}   ]
        
        # 0 = No (default) | 1 = Contra-indicated / not tolerated | 2 = On maximum tolerated dose | 3 = Yes         
        xml.puts Report::ExtractController.xml_value( 'Metformin', c.data.metf_metformin, 's',map_no_contra_max_yes)
        # 0 = No (default) | 1 = Contra-indicated / not tolerated | 2 = On maximum tolerated dose | 3 = Yes         
        xml.puts Report::ExtractController.xml_value( 'Sulphonylurea', c.data.sulp_sulphonylurea, 's',map_no_contra_max_yes)
        # 0 = No (default) | 1 = Contra-indicated / not tolerated | 2 = On maximum tolerated dose | 3 = Yes         
        xml.puts Report::ExtractController.xml_value( 'Glitazone', c.data.glit_glitazone, 's',map_no_contra_max_yes)
        # 0 = No (default) | 1 = Contra-indicated / not tolerated | 2 = On maximum tolerated dose | 3 = Yes         
        xml.puts Report::ExtractController.xml_value( 'Acarbose', c.data.acar_acarbose, 's',map_no_contra_max_yes)
       
        xml.puts '</ClinicalDataDiabetes>'
        # ===============================================
        xml.puts '</Record>'
      end
      xml.puts '</Message>'      
    end
    
    send_file(tmp_xml,:type => 'text/plain', :filename => "PHO-#{@criteria.pho_id}-CVDR-#{@criteria.start_date.to_s(:db)[0,7]}-#{@criteria.end_date.to_s(:db)[0,7]}.xml" )
    
    nil
  end

  
  def self.xml_value_nil(tag,value,datatype)
    nil_attr=' xsi:nil="true"' if value.blank?
    "<#{tag}#{nil_attr}>#{value}</#{tag}>"
  end
  
  def self.xml_value(tag,value,datatype,map=nil)
    return '' if value.blank?
    value = value.to_date.to_s(:db) if datatype == 'd'
    value = value.to_s
    if ( map ) 
       # Have a mapping
       mapped=false
       map.each do |e|
         if ( e[:match].match(value) ) 
           value = e[:mapto]
           mapped=true
           break;
         end
      end
      if ( ! mapped )
        logger.info "CVD XML - Cannot map #{value} for #{tag}"
        return ''
      end
    end
    "<#{tag}>#{CGI.escapeHTML(value)}</#{tag}>"
  end

  
end
