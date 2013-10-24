class Report::AuditController < Report::BaseController

  # Extend Criteria Class
  
  
  def criteria
    # Need an object, So can set the defaults on the date 
    @criteria = Criteria.new
    
    @criteria.end_date = Date.today.end_of_month # last_month
    @criteria.start_date = @criteria.end_date.at_beginning_of_month.months_since( -11 )
    @criteria.programme_id = Programme.first(:conditions => { :deleted => false }).id
    @criteria.max_claims = 1;
    
    @criteria.restore_from_session(session)
    
  end 
  
  def result
    @criteria = Criteria.new(params[:criteria])

    @criteria.start_date = @criteria.start_date.at_beginning_of_month
    @criteria.end_date = @criteria.end_date.end_of_month
    
    @criteria.save_to_session(session)  
    
    @results = []
    
    # patients not seen
    
    session[:audit] ||= {}
    
    filter_sql = '1=1'
    filter_descr = ''
    
    if ( @criteria.high_needs == 'h' ) 
      filter_descr = 'High Needs Only'
      filter_sql = '((p.quintile = 5) OR (p.ethnicity_id >= 20 and p.ethnicity_id < 40))'
    end
    if ( @criteria.high_needs == 'n' ) 
      filter_descr = 'Non High Needs Only'
      filter_sql = '(NOT((p.quintile = 5) OR (p.ethnicity_id >= 20 and p.ethnicity_id < 40)))'
    end
    unless ( @criteria.organisation_id.blank?  ) 
      filter_sql = filter_sql + " and p.organisation_id = #{@criteria.organisation_id}"
    end

    ticked=params[:patients_with_outstanding_reminders]
    session[:audit][:patients_with_outstanding_reminders] = ticked
    if ticked
      query = Query.find_by_sql([
          "select c.organisation_id,p.id patient_id, p.nhi_no, p.family_name, p.given_names,p.date_of_birth, c.date_service, s.reminder_note note\n"+
          "from claims c\n"+
          "  left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "  left join claims cfuture on  cfuture.patient_id = c.patient_id\n"+
          "      and cfuture.programme_id = c.programme_id and cfuture.date_service > c.date_service and cfuture.claim_status_id <= 6\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "where c.programme_id  = ?\n"+
          "  and c.date_service >= ?  and c.date_service <= ?\n"+
          "  and c.claim_status_id <= 6\n"+
          "  and s.reminder_on = 1\n"+
          "  and ( c.date_service+s.reminder_in_weeks*7 < cast( ? as datetime ))\n"+
          "  and #{filter_sql}\n"+
          "  and cfuture.id is null\n"+
          "order by c.organisation_id, c.date_service\n",
              @criteria.programme_id,
              @criteria.start_date,@criteria.end_date,Date.today] )
      for g in query.in_groups_by(&:organisation_id) do
         @results << { :title => 'Patients With Reminders', 
                       :note => '',
                       :filter => filter_descr,
                       :organisation_id => g[0].organisation_id,
                       :query => g }
      end
    end    

   
    ticked=params[:patients_not_seen_less_than_max_claims]
    session[:audit][:patients_not_seen_less_than_max_claims] = ticked
    if ( ticked )
      if ( @criteria.programme_id == Programme::CPLUS || @criteria.programme_id == Programme::CPW || @criteria.programme_id == Programme::CPWD )
        # i.e. Look for claims from (START-12Mths) to (START) OR Care Plus that dont have a claim in the future (>START)
        # Also include all Care plus patients
        query = Query.find_by_sql([
            "select p.organisation_id, p.nhi_no, p.family_name, p.given_names,p.date_of_birth, max(allc.date_service) date_service, count(c.id) numclaims\n"+
            "from patients p\n"+
            "  left join claims c on c.patient_id = p.id\n"+
            "      and c.programme_id = ? and c.date_service >= ?  and c.date_service <= ? and c.claim_status_id <= 6\n"+
            "  left join claims allc on allc.patient_id = p.id\n"+
            "      and allc.programme_id = ? and allc.date_service >= ?  and allc.date_service <= ? and allc.claim_status_id <= 6\n"+
            "where p.is_care_plus = 1\n"+
            "  and p.organisation_id is not null\n"+
            "  and #{filter_sql}\n"+
            "group by p.organisation_id, p.nhi_no, p.family_name, p.given_names,p.date_of_birth\n" +
            "having count(c.id) < ?\n"+
            "order by p.organisation_id, max(c.date_service)", 
              @criteria.programme_id,@criteria.start_date,@criteria.end_date,
              @criteria.programme_id,@criteria.start_date.months_since( -12 ),@criteria.end_date,
                 @criteria.max_claims.to_i ] )
      else  
        # i.e. Look for claims from (START-12Mths) to (START) that dont have a claim in the future (>START)
        query = Query.find_by_sql([
            "select p.organisation_id, p.nhi_no, p.family_name, p.given_names,p.date_of_birth, isnull(max(ccount.date_service),max(c.date_service)) date_service, count(ccount.id) numclaims\n"+
            "from claims c\n"+
            "  left join patients p on p.id = c.patient_id\n"+
            "    left join claims ccount on ccount.patient_id = c.patient_id\n"+
            "       and ccount.programme_id = ? and ccount.date_service >= ? and ccount.date_service <= ? and ccount.claim_status_id <= 6\n"+
            "where c.programme_id = ? and c.date_service >= ?  and c.date_service < ? \n"+
            "   and c.claim_status_id <= 6\n"+
            "   and #{filter_sql}\n"+
            "   and p.organisation_id is not null\n"+
            "group by p.organisation_id, p.nhi_no, p.family_name, p.given_names,p.date_of_birth\n"+
            "having count(ccount.id) < ?\n"+
            "order by p.organisation_id,max(c.date_service)", 
              @criteria.programme_id,@criteria.start_date,@criteria.end_date,
                 @criteria.programme_id,@criteria.start_date.months_since( -12 ),@criteria.start_date,
                 @criteria.max_claims.to_i ] )
      end
               
              
      for g in query.in_groups_by(&:organisation_id) do
         @results << { :title => ( @criteria.max_claims > 1 ? "Patients seen less than #{@criteria.max_claims} times" : 'Patients Not Seen'), 
                       :note => ", since #{@criteria.start_date.to_s(:local)}",
                       :filter => filter_descr,
                       :organisation_id => g[0].organisation_id,
                       :query => g }
      end
    end

    ticked=params[:patients_with_treatment_alerts] # Diabetes / CVDR only
    session[:audit][:patients_with_treatment_alerts] = ticked
    if ticked
      query = Query.find_by_sql([
          "select p.organisation_id,o.name organisation_name, p.nhi_no, p.family_name, p.given_names,\n"+
          "       p.date_of_birth, max(c.date_service) date_service, dbo.treatment_alerts(p.id) note\n"+
          "from claims c\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "  left join organisations o on o.id = p.organisation_id\n"+
          "where  ( c.programme_id = ? or c.programme_id = ? ) and c.date_service >= ?  and c.date_service <= ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and p.organisation_id > 0\n"+
          "   and #{filter_sql}\n"+
          "   and dbo.treatment_alerts(p.id) <> ''\n"+
          "group by p.organisation_id,o.name, p.nhi_no, p.family_name, p.given_names, p.date_of_birth, p.id\n"+
          "order by p.organisation_id, max(c.date_service)",
              Programme::CVDR, Programme::DIAB, 
              @criteria.start_date,@criteria.end_date] )
      for g in query.in_groups_by(&:organisation_id) do
         @results << { :title => 'Patients With Treatment Alerts', 
                       :note => 'Diabetes/CVD',
                       :filter => filter_descr,
                       :organisation_id => g[0].organisation_id,
                       :query => g }
      end
    end    
    
    
    ticked=params[:patients_over_serviced]
    session[:audit][:patients_over_serviced] = ticked
    if ticked
      query = Query.find_by_sql([
          "select c.organisation_id,p.id patient_id, p.nhi_no, p.family_name, p.given_names,p.date_of_birth, count(c.id) count\n"+
          "from claims c\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "where c.programme_id = ? and c.date_service >= ?  and c.date_service <= ?\n"+
          "  and c.claim_status_id <= 6\n"+
          "   and #{filter_sql}\n"+
          "group by c.organisation_id,p.id,p.nhi_no, p.family_name, p.given_names,p.date_of_birth\n"+
          "having count(c.id) > ?\n"+
          "order by c.organisation_id,count(c.id) desc", 
            @criteria.programme_id,@criteria.start_date,@criteria.end_date,@criteria.max_claims] )
            
      for g in query.in_groups_by(&:organisation_id) do
         @results << { :title => 'Patients Over Serviced', 
                       :note => nil,
                       :filter => filter_descr,
                       :organisation_id => g[0].organisation_id,
                       :query => g }
      end
    end
    
    
    
    ticked=params[:patients_with_sub_optimal_hb_a1c] # Without a managment plan 
    session[:audit][:patients_with_sub_optimal_hb_a1c] = ticked
    if ticked
      query = Query.find_by_sql([
          "select c.organisation_id,o.name organisation_name, p.nhi_no, p.family_name, p.given_names,p.date_of_birth, c.date_service, d.hba1c_hba1c data\n"+
          "from claims c\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "  left join organisations o on o.id = c.organisation_id\n"+
          "where c.programme_id = ? and c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.claim_status_id <= 6\n"+
          "   and (( d.hba1c_hba1c >= 7.0 and d.hba1c_hba1c < 13.0 ) OR \n"+
          "        ( d.hba1c_hba1c >= 53.0 and d.hba1c_hba1c < 199.0 ))\n"+
          "   and #{filter_sql}\n"+
          "   and not exists\n"+
          " ( select 1 from claims m\n"+
          "    where m.patient_id = c.patient_id\n"+
          "      and m.programme_id = c.programme_id\n"+ 
          "      and m.date_service > c.date_service )\n"+
          "order by c.organisation_id,d.hba1c_hba1c desc, c.date_service", 
            @criteria.programme_id,@criteria.start_date,@criteria.end_date] )
      for g in query.in_groups_by(&:organisation_id) do
         @results << { :title => 'Patients With Sub-Optimal HbA1c', 
                       :filter => filter_descr,
                       :note => '(Hba1c &ge; 7%,53 mmol/mol)',
                       :data_heading => 'Hba1c',
                       :organisation_id => g[0].organisation_id,
                       :query => g }
      end
    end    
    
    ticked=params[:patients_with_high_cvd_risk] # Without a managment plan 
    session[:audit][:patients_with_high_cvd_risk] = ticked
    if ticked
      query = Query.find_by_sql([
          "select c.organisation_id,o.name organisation_name, p.nhi_no, p.family_name, p.given_names,p.date_of_birth, c.date_service,\n"+
          " ( CASE WHEN ( d.cvdr_cvd_risk >= 25 ) THEN 'HH' ELSE CAST( CAST(d.cvdr_cvd_risk as integer) as VARCHAR(8)) END ) data\n"+
          "from claims c\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "  left join organisations o on o.id = c.organisation_id\n"+
          "where c.programme_id = ? and c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.claim_status_id <= 6\n"+
          "   and c.fee_schedule_id in (20,24,201)\n"+
          "   and d.cvdr_cvd_risk > 15.0\n"+
          "   and #{filter_sql}\n"+
          "   and not exists\n"+
          " ( select 1 from claims m\n"+
          "    where m.patient_id = c.patient_id\n"+
          "      and  m.programme_id = c.programme_id\n"+ 
          "      and ( m.fee_schedule_id in ( 21,22,23,25,26,202 )\n"+
          "      and m.date_service >= c.date_service ))\n"+
          "order by c.organisation_id,c.date_service", 
            @criteria.programme_id,@criteria.start_date,@criteria.end_date] )
      for g in query.in_groups_by(&:organisation_id) do
         @results << { :title => 'Patients with High CVD Risk', 
                       :filter => filter_descr,
                       :note => '(&gt; 15%) and no managment plan',
                       :data_heading => 'Risk',
                       :organisation_id => g[0].organisation_id,
                       :query => g }
      end
    end    

    # Patients with 2 or more (est) health factors and not on care plus
    ticked=params[:patients_with_multiple_risk_factors]
    session[:audit][:patients_with_multiple_risk_factors] = ticked
    if ticked
      query = Query.find_by_sql([
          "select p.organisation_id,o.name organisation_name, p.nhi_no, p.family_name, p.given_names,\n"+
          "       p.date_of_birth, max(c.date_service) date_service, dbo.healthf2(p.id) note\n"+
          "from claims c\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "  left join organisations o on o.id = p.organisation_id\n"+
          "where c.date_service >= ?  and c.date_service <= ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and p.organisation_id > 0\n"+
          "   and p.is_care_plus = 0\n"+
          "   and #{filter_sql}\n"+
          "   and dbo.healthf2(p.id) is not null\n"+
          "group by p.organisation_id,o.name, p.nhi_no, p.family_name, p.given_names, p.date_of_birth, p.id\n"+
          "order by p.organisation_id, max(c.date_service)",
            @criteria.start_date,@criteria.end_date] )
     # <%= ( q.cvd_risk.to_f >= 35.00 ? 'HH' : q.cvd_risk ) if q.respond_to?('cvd_risk') %>
         
      for g in query.in_groups_by(&:organisation_id) do
         @results << { :title => 'Patients With Multiple (estimated) Risk Factors', 
                       :note => 'and not enrolled in care plus',
                       :filter => filter_descr,
                       :organisation_id => g[0].organisation_id,
                       :query => g }
      end
    end    

    ticked=params[:patients_with_cvdr_exceptions]
    session[:audit][:patients_with_cvdr_exceptions] = ticked
    if ticked
      query = Query.find_by_sql([
          "select p.organisation_id,o.name organisation_name, p.nhi_no, p.family_name, p.given_names,\n"+
          "       p.date_of_birth, max(c.date_service) date_service, cast('CVD Risk Claim, No Risk Recorded' as varchar(78)) note\n"+
          "from claims c\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "  left join organisations o on o.id = p.organisation_id\n"+
          "where c.date_service >= ? and c.date_service <= ? \n"+
          " and c.programme_id = 2\n"+
          " and c.fee_schedule_id in ( 20, 22, 24, 26, 201, 202 )\n"+
          " and c.claim_status_id <= 6\n"+
          " and p.organisation_id > 0\n"+
          " and (( d.cvdr_cvd_risk is null ) or ( d.cvdr_cvd_risk = 0 ))\n"+
          "group by p.organisation_id,o.name, p.nhi_no, p.family_name, p.given_names, p.date_of_birth, p.id\n"+
#          "UNION\n"+
#          "select p.organisation_id,o.name organisation_name, p.nhi_no, p.family_name, p.given_names,\n"+
#          "       p.date_of_birth, max(c.date_service) date_service, cast('CVD Risk Claim, Not Elibiable' as varchar(78)) note\n"+
#          "from claims c\n"+
#          "  left join claims_data d on d.id = c.id\n"+
#          "  left join patients p on p.id = c.patient_id\n"+
#          "  left join organisations o on o.id = p.organisation_id\n"+
#          "where c.date_service >= ? and c.date_service <= ? \n"+
#          " and c.programme_id = 2\n"+
#          " and c.fee_schedule_id in ( 20, 22, 24, 26 )\n"+
#          " and c.claim_status_id <= 6\n"+
#          " and p.organisation_id > 0\n"+
#          " and dbo.cvd_eligible(p.date_of_birth,p.gender_id,p.ethnicity_id,c.date_service) = 0 \n"+
#          " and d.cvdr_cvd_risk > 0\n"+
#          "group by p.organisation_id,o.name, p.nhi_no, p.family_name, p.given_names, p.date_of_birth, p.id\n"+
          "UNION\n"+
          "select p.organisation_id,o.name organisation_name, p.nhi_no, p.family_name, p.given_names,\n"+
          "       p.date_of_birth, max(c.date_service) date_service, cast('CVD Mgmt Plan, Not High Risk' as varchar(78)) note\n"+
          "from claims c\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "  left join organisations o on o.id = p.organisation_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          " and c.programme_id = 2\n"+
          " and c.fee_schedule_id in ( 21, 22, 25, 26, 202 )\n"+
          " and c.claim_status_id <= 6\n"+
          " and p.organisation_id > 0\n"+
          " and NOT exists ( select 1 \n"+
          "   from claims xc \n"+
          "      left join claims_data xd on xd.id = xc.id\n"+
          "    where xc.patient_id = c.patient_id\n"+
          "      and xc.date_service >= '20080101' \n"+
          "      and xc.date_service <= c.date_service \n"+
          "      and xc.programme_id = 2\n"+
          "      and xc.claim_status_id <= 6\n"+
          "      and xd.cvdr_cvd_risk >= 15 )  \n"+
          "group by p.organisation_id,o.name, p.nhi_no, p.family_name, p.given_names, p.date_of_birth, p.id\n"+
          "order by 1,8\n",
            @criteria.start_date,@criteria.end_date,
#            @criteria.start_date,@criteria.end_date,
            @criteria.start_date,@criteria.end_date] )
      
      for g in query.in_groups_by(&:organisation_id) do
         @results << { :title => 'CVDR Exceptions', 
                       :filter => filter_descr,
                       :note => '',
                       :organisation_id => g[0].organisation_id,
                       :query => g }
      end
    end    

    ticked=params[:patients_with_outstanding_b4_school_checks]
    session[:audit][:patients_with_outstanding_b4_school_checks] = ticked
    if ticked
      query = Query.find_by_sql([
          "select p.organisation_id organisation_id, p.id patient_id, p.nhi_no, p.family_name, p.given_names,p.date_of_birth,\n"+
          "  dbo.ageym(p.date_of_birth,?) data\n"+
          "from patients p\n"+
          "  left join organisations o on o.id = p.organisation_id\n"+
          "  left join claims c on c.patient_id = p.id\n"+
          "    and c.programme_id = #{Programme::B4SC}\n"+
          "    and c.claim_status_id <= 6\n"+
          "where p.organisation_id is not null\n"+
          "  and dbo.ageym(p.date_of_birth,?) like ' 4Y%'\n"+
          "  and #{filter_sql}\n"+
          "  and c.id is null\n"+
          "order by p.organisation_id, p.date_of_birth\n",@criteria.end_date,@criteria.end_date] )
          
          
      for g in query.in_groups_by(&:organisation_id) do
         @results << { :title => 'Patients With Outstanding B4 School Checks', 
                       :filter => filter_descr,
                       :note => "(4 year old patients as at #{@criteria.end_date.to_s(:local)})",
                       :data_heading => 'Age',
                       :organisation_id => g[0].organisation_id,
                       :query => g }
      end
    end


    
    
    
    ticked=params[:patients_with_outstanding_b4_school_referrals]
    session[:audit][:patients_with_outstanding_b4_school_referrals] = ticked
    if ticked
      where_part = ''
      
      # Added option to exclude various types of referrals.
      ticked=params[:chqre_child_heath_q_referral]
      session[:audit][:chqre_child_heath_q_referral] = ticked
      if ( !ticked ) 
        where_part +=  "  (( chqre_child_heath_q_referral <> '' and chqre_child_heath_q_referral not like 'decl%' and chqre_child_heath_q_referral not like 'n/a%' ) and ( chqres_child_heath_q_referral_status is null or chqres_child_heath_q_referral_status = '' ))"
      end
      
      ticked=params[:dentre_dental_referral]
      session[:audit][:dentre_dental_referral] = ticked
      if ( !ticked ) 
        where_part += "\nOR " if where_part.length > 0 
        where_part += "  (( dentre_dental_referral <> '' and dentre_dental_referral not like 'decl%' and dentre_dental_referral not like 'n/a%' ) and ( dentres_dental_referral_status is null or dentres_dental_referral_status = '' ))"
      end

      ticked=params[:growre_growth_measure_referral]
      session[:audit][:growre_growth_measure_referral] = ticked
      if ( !ticked ) 
        where_part += "\nOR " if where_part.length > 0 
        where_part += "  (( growre_growth_measure_referral <> '' and growre_growth_measure_referral not like 'decl%' and growre_growth_measure_referral not like 'n/a%' ) and ( growres_growth_measure_referral_status is null or growres_growth_measure_referral_status = '' ))"
      end

      ticked=params[:immre_immunisation_referral]
      session[:audit][:immre_immunisation_referral] = ticked
      if ( !ticked ) 
        where_part += "\nOR " if where_part.length > 0 
        where_part += "  (( immre_immunisation_referral <> '' and immre_immunisation_referral not like 'decl%' and immre_immunisation_referral not like 'n/a%' ) and ( immres_immunisation_referral_status is null or immres_immunisation_referral_status = '' ))"
      end
      
      ticked=params[:pedsref_peds_referral]
      session[:audit][:pedsref_peds_referral] = ticked
      if ( !ticked ) 
        where_part += "\nOR " if where_part.length > 0 
        where_part += "  (( pedsref_peds_referral <> '' and pedsref_peds_referral not like 'decl%' and pedsref_peds_referral not like 'n/a%' ) and ( pedsrefs_peds_referral_status is null or pedsrefs_peds_referral_status = '' )) OR "
        where_part += "  (( pedsref2_peds_referral_2 <> '' and pedsref2_peds_referral_2 not like 'decl%' and pedsref2_peds_referral_2 not like 'n/a%' ) and ( pedsref2s_peds_referral_2_status is null or pedsref2s_peds_referral_2_status = '' ))"
      end
      
      ticked=params[:sdqref_sdq_referral]
      session[:audit][:sdqref_sdq_referral] = ticked
      if ( !ticked ) 
        where_part += "\nOR " if where_part.length > 0 
        where_part += "  (( sdqref_sdq_referral <> '' and sdqref_sdq_referral not like 'decl%' and sdqref_sdq_referral not like 'n/a%' ) and ( sdqrefs_sdq_referral_status is null or sdqrefs_sdq_referral_status = '' )) OR "
        where_part += "  (( sdqref2_sdq_referral_2 <> '' and sdqref2_sdq_referral_2 not like 'decl%' and sdqref2_sdq_referral_2 not like 'n/a%' ) and ( sdqref2s_sdq_referral_2_status is null or sdqref2s_sdq_referral_2_status = '' ))"
      end
      
      ticked=params[:vishr_vision_hearing_referral]
      session[:audit][:vishr_vision_hearing_referral] = ticked
      if ( !ticked ) 
        where_part += "\nOR " if where_part.length > 0 
        where_part += "  (( vishr_vision_hearing_referral <> '' and vishr_vision_hearing_referral not like 'decl%' and vishr_vision_hearing_referral not like 'n/a%' ) and ( vishrs_vision_hearing_referral_status is null or vishrs_vision_hearing_referral_status = '' ))"
      end
      
      where_part = '1=2' if where_part.length == 0; # Exclude all, No rows to fetch

      
      query = Query.find_by_sql([
          "select c.id claim_id, c.organisation_id,o.name organisation_name, p.nhi_no, p.family_name, p.given_names,p.date_of_birth, c.date_service,\n"+
          # Output details of the outstanding referrals 
          "(( CASE WHEN (( chqre_child_heath_q_referral <> '' and chqre_child_heath_q_referral not like 'decl%' and chqre_child_heath_q_referral not like 'n/a%' ) and ( chqres_child_heath_q_referral_status is null or chqres_child_heath_q_referral_status = '' )) THEN 'Chq: ' + chqre_child_heath_q_referral + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN (( dentre_dental_referral <> '' and dentre_dental_referral not like 'decl%' and dentre_dental_referral not like 'n/a%' ) and ( dentres_dental_referral_status is null or dentres_dental_referral_status = '' ))  THEN 'Dental: ' + dentre_dental_referral + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN (( growre_growth_measure_referral <> '' and growre_growth_measure_referral not like 'decl%' and growre_growth_measure_referral not like 'n/a%' ) and ( growres_growth_measure_referral_status is null or growres_growth_measure_referral_status = '' ))  THEN 'Growth: ' + growre_growth_measure_referral + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN (( immre_immunisation_referral <> '' and immre_immunisation_referral not like 'decl%' and immre_immunisation_referral not like 'n/a%' ) and ( immres_immunisation_referral_status is null or immres_immunisation_referral_status = '' ))  THEN 'Imm: ' + immre_immunisation_referral + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN (( pedsref_peds_referral <> '' and pedsref_peds_referral not like 'decl%' and pedsref_peds_referral not like 'n/a%' ) and ( pedsrefs_peds_referral_status is null or pedsrefs_peds_referral_status = '' ))  THEN 'Peds: ' + pedsref_peds_referral + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN (( pedsref2_peds_referral_2 <> '' and pedsref2_peds_referral_2 not like 'decl%' and pedsref2_peds_referral_2 not like 'n/a%' ) and ( pedsref2s_peds_referral_2_status is null or pedsref2s_peds_referral_2_status = '' ))  THEN 'Peds: ' + pedsref2_peds_referral_2 + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN (( sdqref_sdq_referral <> '' and sdqref_sdq_referral not like 'decl%' and sdqref_sdq_referral not like 'n/a%' ) and ( sdqrefs_sdq_referral_status is null or sdqrefs_sdq_referral_status = '' ))  THEN 'Sdq: ' + sdqref_sdq_referral + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN (( sdqref2_sdq_referral_2 <> '' and sdqref2_sdq_referral_2 not like 'decl%' and sdqref2_sdq_referral_2 not like 'n/a%' ) and ( sdqref2s_sdq_referral_2_status is null or sdqref2s_sdq_referral_2_status = '' ))  THEN 'Sdq: ' + sdqref2_sdq_referral_2 + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN (( vishr_vision_hearing_referral <> '' and vishr_vision_hearing_referral not like 'decl%' and vishr_vision_hearing_referral not like 'n/a%' ) and ( vishrs_vision_hearing_referral_status is null or vishrs_vision_hearing_referral_status = '' ))  THEN 'Vision: ' + vishr_vision_hearing_referral + '. ' ELSE '' END )) note\n"+
          "from claims c\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "  left join organisations o on o.id = c.organisation_id\n"+
          "where c.programme_id = ? and c.date_service >= ?  and c.date_service <= ? \n"+
          "  and c.claim_status_id <= 6\n"+
          "  and #{filter_sql}\n"+
          "  and (\n #{where_part})\n"+
          "order by c.organisation_id,c.date_service", 
            @criteria.programme_id,@criteria.start_date,@criteria.end_date] )
            
      @claim_csv = []
      ticked=params[:b4school_simple_list]
      session[:audit][:b4school_simple_list] = ticked
      if ( ticked )
         @results << { :title => 'Outstanding B4School Referrals', 
                       :filter => filter_descr,
                       :note => '',
                       :organisation_id => nil,
                       :query => query }
      else
        for g in query.in_groups_by(&:organisation_id) do
         g.inject(@claim_csv) { |arr,row| arr << row.claim_id }
         @results << { :title => 'Outstanding B4School Referrals', 
                       :filter => filter_descr,
                       :note => '',
                       :organisation_id => g[0].organisation_id,
                       :query => g }
        end
      end

      
      # Save in the session
      session[:claims_ids] = @claim_csv;
    end


    ticked=params[:completed_b4_school_referrals]
    session[:audit][:completed_b4_school_referrals] = ticked
    if ticked
      @claim_csv = []
      query = Query.find_by_sql([
          "select c.id claim_id, c.organisation_id,o.name organisation_name, p.nhi_no, p.family_name, p.given_names,p.date_of_birth, c.date_service,\n"+
          # -- Output note, Indicating Referral and its status, for each referral made.
          "(( CASE WHEN ( chqre_child_heath_q_referral <> '' and chqre_child_heath_q_referral not like 'decl%' and chqre_child_heath_q_referral not like 'n/a%' ) \n"+
          "   THEN 'Chq: ' + chqre_child_heath_q_referral + ' - ' + chqres_child_heath_q_referral_status + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN ( dentre_dental_referral <> '' and dentre_dental_referral not like 'decl%' and dentre_dental_referral not like 'n/a%' )  \n"+
          "   THEN 'Dental: ' + dentre_dental_referral + ' - ' + dentres_dental_referral_status + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN ( growre_growth_measure_referral <> '' and growre_growth_measure_referral not like 'decl%' and growre_growth_measure_referral not like 'n/a%' )\n"+
          "   THEN 'Growth: ' + growre_growth_measure_referral + ' - ' + growres_growth_measure_referral_status + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN ( immre_immunisation_referral <> '' and immre_immunisation_referral not like 'decl%' and immre_immunisation_referral not like 'n/a%' )  \n"+
          "   THEN 'Imm: ' + immre_immunisation_referral + ' - ' + immres_immunisation_referral_status + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN ( pedsref_peds_referral <> '' and pedsref_peds_referral not like 'decl%' and pedsref_peds_referral not like 'n/a%' )\n"+
          "   THEN 'Peds: ' + pedsref_peds_referral + ' - ' + pedsrefs_peds_referral_status + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN ( pedsref2_peds_referral_2 <> '' and pedsref2_peds_referral_2 not like 'decl%' and pedsref2_peds_referral_2 not like 'n/a%' )\n"+
          "   THEN 'Peds: ' + pedsref2_peds_referral_2 + ' - ' + pedsref2s_peds_referral_2_status + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN ( sdqref_sdq_referral <> '' and sdqref_sdq_referral not like 'decl%' and sdqref_sdq_referral not like 'n/a%' )\n"+
          "   THEN 'Sdq: ' + sdqref_sdq_referral + ' - ' + sdqrefs_sdq_referral_status + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN ( sdqref2_sdq_referral_2 <> '' and sdqref2_sdq_referral_2 not like 'decl%' and sdqref2_sdq_referral_2 not like 'n/a%' )\n"+
          "   THEN 'Sdq: ' + sdqref2_sdq_referral_2 + ' - ' + sdqref2s_sdq_referral_2_status + '. ' ELSE '' END ) +\n"+
          " ( CASE WHEN ( vishr_vision_hearing_referral <> '' and vishr_vision_hearing_referral not like 'decl%' and vishr_vision_hearing_referral not like 'n/a%' )\n"+
          "   THEN 'Vision: ' + vishr_vision_hearing_referral + ' - ' + vishrs_vision_hearing_referral_status + '. ' ELSE '' END )) note\n"+
          "from claims c\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "  left join organisations o on o.id = c.organisation_id\n"+
          "where c.programme_id = ? and c.date_service >= ?\n"+
          "  and c.updated_at >= ? and c.updated_at <= ? \n"+
          "  and c.claim_status_id <= 6\n"+
          "  and #{filter_sql}\n"+
          "  and (  \n"+
          #  -- SQL to find close referrals, either no referral made, or referral(s) made and now have its status recorded
          "  ( chqre_child_heath_q_referral is null or chqre_child_heath_q_referral = '' or\n"+
          "    chqre_child_heath_q_referral like 'decl%' or chqre_child_heath_q_referral like 'n/a%' or \n"+
          "    chqres_child_heath_q_referral_status <> '' ) AND \n"+
          "  ( dentre_dental_referral is null or dentre_dental_referral = '' or\n"+
          "    dentre_dental_referral like 'decl%' or dentre_dental_referral like 'n/a%' or \n"+
          "    dentres_dental_referral_status <> '' ) AND \n"+
          "  ( growre_growth_measure_referral is null or growre_growth_measure_referral = '' or\n"+
          "    growre_growth_measure_referral like 'decl%' or growre_growth_measure_referral like 'n/a%' or \n"+
          "    growres_growth_measure_referral_status <> '' ) AND \n"+
          "  ( immre_immunisation_referral is null or immre_immunisation_referral = '' or\n"+
          "    immre_immunisation_referral like 'decl%' or immre_immunisation_referral like 'n/a%' or \n"+
          "    immres_immunisation_referral_status <> '' ) AND \n"+
          "  ( pedsref_peds_referral is null or pedsref_peds_referral = '' or\n"+
          "    pedsref_peds_referral like 'decl%' or pedsref_peds_referral like 'n/a%' or \n"+
          "    pedsrefs_peds_referral_status <> '' ) AND \n"+
          "  ( pedsref2_peds_referral_2 is null or pedsref2_peds_referral_2 = '' or\n"+
          "    pedsref2_peds_referral_2 like 'decl%' or pedsref2_peds_referral_2 like 'n/a%' or \n"+
          "    pedsref2s_peds_referral_2_status <> '' ) AND \n"+
          "  ( sdqref_sdq_referral is null or sdqref_sdq_referral = '' or\n"+
          "    sdqref_sdq_referral like 'decl%' or sdqref_sdq_referral like 'n/a%' or \n"+
          "    sdqrefs_sdq_referral_status <> '' ) AND \n"+
          "  ( sdqref2_sdq_referral_2 is null or sdqref2_sdq_referral_2 = '' or\n"+
          "    sdqref2_sdq_referral_2 like 'decl%' or sdqref2_sdq_referral_2 like 'n/a%' or \n"+
          "    sdqref2s_sdq_referral_2_status <> '' ) AND \n"+
          "  ( vishr_vision_hearing_referral is null or vishr_vision_hearing_referral = '' or\n"+
          "    vishr_vision_hearing_referral like 'decl%' or vishr_vision_hearing_referral like 'n/a%' or \n"+
          "    vishrs_vision_hearing_referral_status <> '' ))\n"+
          "order by c.organisation_id,c.date_service\n",
          @criteria.programme_id,@criteria.start_date.months_since( -12 ),@criteria.start_date,@criteria.end_date ] )
      
      
      for g in query.in_groups_by(&:organisation_id) do
         g.inject(@claim_csv) { |arr,row| arr << row.claim_id }
         @results << { :title => 'Completed B4School Referrals', 
                       :filter => filter_descr,
                       :note => '',
                       :organisation_id => g[0].organisation_id,
                       :query => g }
      end
      # Save in the session
      session[:claims_ids] = @claim_csv;
    end    




    if ( @results.length == 0  )
      flash[:alert] = 'No records found'
      redirect_to :action => 'criteria'
    end
  end
  
  def csv
    conditions = 'c.id in (' + session[:claims_ids].join(',') + ')';
    
    content_type = ( request.user_agent =~ /windows/i ?  'application/vnd.ms-excel' : 'text/csv' )
    content = Claim.csv_by_conditions(conditions, User.cache(session[:user_id]).show_name_address_csv )
    send_data(content,:type => content_type, :filename => 'claims.csv' )
  end

  
  
end
