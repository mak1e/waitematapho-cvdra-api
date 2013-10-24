class Report::UtilisationController < Report::BaseController
 
   
  def criteria
    # Need an object, So can set the defaults on the date 
    @criteria = Criteria.new
    @criteria.start_date = Date.today.at_beginning_of_month.last_month
    @criteria.end_date = @criteria.start_date.end_of_month
    @criteria.start_date = @criteria.start_date.months_since( -2 )    # Default to a Qtr
    
    @criteria.restore_from_session(session)
  end 
  
  
  # Run cvdr query for patients who have had a risk assessment
  # eligability is determined by age at time of assessment
  def run_cvdr_risk_assess_query(filter)
      filter = '1=1' if filter.blank?
      query = Query.find_by_sql([
        "select e.order_by_cvdr orderby, e.ethnicity_cvdr ethnicity, count(distinct c.patient_id) count\n"+
        "from claims c\n"+
        "  left join claims_data d on d.id = c.id\n"+
        "  left join patients p on p.id = c.patient_id\n"+
        "  left join ethnicities e on e.id = IsNull(p.ethnicity_id,#{Ethnicity::OTHER})\n"+
        "where c.date_service >= ? and c.date_service <= ?\n"+
        " and c.programme_id = ?\n"+
        " and c.claim_status_id <= 6\n"+
        " and d.cvdr_cvd_risk > 0\n"+
        " and #{filter}\n"+
        "group by e.order_by_cvdr, e.ethnicity_cvdr\n"+
        "order by 1\n",
         @criteria.start_date, @criteria.end_date, @criteria.programme_id])
      query
  end  
  
#  def run_cvdr_count(filter)
#      filter = '1=1' if filter.blank?
#      query = Query.find_by_sql([
#        "select count(c.id) count\n"+
#        "from claims c\n"+
#        "  left join claims_data d on d.id = c.id\n"+
#        "  left join patients p on p.id = c.patient_id\n"+
#        "where c.date_service >= ?  and c.date_service <= ? \n"+
#        " and c.programme_id = ?\n"+
#        " and c.claim_status_id <= 6\n"+
#        " and d.cvdr_cvd_risk > 0\n"+
#        " and #{filter}\n"+
#        " and c.fee_schedule_id <> #{FeeSchedule::B4SC_DECLINED}\n"+
#        # Exclude if a more recient "accepted" claim exists for the patient !!
#        "  and not exists ( select 1 \n"+
#        "    from claims xc \n"+
#        "       left join claims_data xd on xd.id = xc.id\n"+
#        "     where xc.patient_id = c.patient_id\n"+
#        "       and xc.date_service > c.date_service and xc.date_service <= ?\n"+
#        "       and xc.claim_status_id <= 6\n"+
#        "       and xc.programme_id = ?\n"+
#        "       and xd.cvdr_cvd_risk > 0 ) \n",
#         @criteria.start_date, @criteria.end_date, @criteria.programme_id,
#         @criteria.end_date,@criteria.programme_id ])
#      query[0].count;
#  end    

  # Run ethnicity query on the database, with a filter 
  def run_eth_query(filter)
      filter = '1=1' if filter.blank?
      query = Query.find_by_sql([
          "select IsNull(el1.id,9),el1.description ethnicity, count(c.id) count\n"+
          "from claims c left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "    left join ethnicities eth on eth.id = p.ethnicity_id \n"+
          "      left join level1_ethnicities el1 on el1.id = eth.level1_ethnicity_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and s.is_a_entry_service = 1\n"+
          "   and #{filter}\n"+
          "group by IsNull(el1.id,9),el1.description\n"+
          "order by 1\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
      query
  end

  def run_diab_query(filter)
      filter = '1=1' if filter.blank?
      query = Query.find_by_sql([
          "select e.ethnicity_diab ethnicity, count(c.id) count\n"+
          "from claims c left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "    left join ethnicities e on e.id = p.ethnicity_id \n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and s.is_a_entry_service = 1\n"+
          "   and s.is_a_declined_service = 0\n"+
          "   and #{filter}\n"+
          "group by e.ethnicity_diab\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
      query
  end
  
  
  def result
    @criteria = Criteria.new(params[:criteria]);
    
    @criteria.start_date = @criteria.start_date.at_beginning_of_month
    @criteria.end_date = @criteria.end_date.end_of_month
    
    @criteria.save_to_session(session)
    
    @results = []
    
    # Add looking for each organisation
    org_loop = [ nil ]
    if ( @criteria.organisation_id.blank? )
      org_loop = [ nil ]
      if ( @criteria.seperate_each_organisation ) 
        query = Query.find_by_sql([
          "select  distinct c.cost_organisation_id, o.name\n"+
          "from claims c\n"+
          "  left join organisations o on o.id = c.cost_organisation_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "order by 2",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id]);
         org_loop = query.map { |r| r.cost_organisation_id.to_i }
      end
    else
      org_loop = [ @criteria.organisation_id.to_i ]
    end

    for org_id in org_loop do 
      
      # Build up and array of hashes, containing the title, partial to render, and the spread sheet
      # First spread sheet contains the criteria for the report, But dont render
        
      @criteria.organisation = nil # Need to do this so lookups organisation again !!!
      @criteria.organisation_id = org_id
        
      @results << { :title => 'Report Criteria', :partial_name => 'section', 
                    :organisation_id => @criteria.organisation_id,  
                    :ss => [ ['Start Date', @criteria.start_date.to_s(:local) ],
                               ['End Date', @criteria.end_date.to_s(:local) ],                    
                               ['Programme',@criteria.programme.description ],                    
                               ['Service',@criteria.fee_schedule_id.blank? ? 'All' : @criteria.fee_schedule.description ],                    
                               ['Organisation',@criteria.organisation_id.blank? ? 'All' : @criteria.organisation.name  ],                    
                               ['Org ID',@criteria.organisation_id  ],                    
                               ['Generated at', Time.now.to_s(:local) ]] }
  
      filter = '1=1'
      filter += "  and c.cost_organisation_id = #{@criteria.organisation_id}\n" unless @criteria.organisation_id.blank?
      filter += "  and c.fee_schedule_id = #{@criteria.fee_schedule_id}\n" unless @criteria.fee_schedule_id.blank?
  
      # Utilisation By Service
      ticked=params[:monthly_trends]
      session[:report][:monthly_trends] = ticked
      if ( ticked )
        query = Query.find_by_sql([
          "select month(c.date_service) mm, year(c.date_service) yyy, count(c.id) count\n"+
          "from claims c left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and s.is_a_entry_service = 1\n"+
          "   and #{filter}\n"+
          "group by month(c.date_service), year(c.date_service)\n"+
          "order by 2,1\n",
           @criteria.start_date.years_ago(1), @criteria.end_date, @criteria.programme_id])
          
        @results << { :title => 'Monthly Trends', :partial_name => 'barchart',
                      :options => { :total => false, :max => true , :showperage => false },
                      :ss => query.map { |r| [ r.yyy.to_s + '-' + r.mm.to_s, r.count.to_i ] } }
   
      end                    
      
      # Utilisation By Service
      ticked=params[:utilisation_by_service]
      session[:report][:utilisation_by_service] = ticked
      if ( ticked )
        query = Query.find_by_sql([
          "select f.description, count(c.id) count\n"+
          "from claims c\n"+
          "  left join fee_schedules f on f.id = c.fee_schedule_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and #{filter}\n"+
          "group by f.description\n"+
          "order by 2 desc\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
          # Convert Query into array hashes. 
          
        @results << { :title => 'Service performed', :partial_name => 'barchart', 
                        :options => { }, :note => '# services',
                        :ss => query.map { |r| [ r.description, r.count.to_i ] } }    
      end                    
  
      # Utilisation By Ethnicity
      ticked=params[:utilisation_by_ethnicity]
      session[:report][:utilisation_by_ethnicity] = ticked
      if ( ticked )
        query = run_eth_query(filter)
        # Convert Query into array hashes. 
        @results << { :title => 'Utilisation by Ethnicity', :partial_name => 'barchart', 
                        :options => { },
                        :ss => query.map { |r| [ r.ethnicity, r.count.to_i ] } }
      end
  
      # Utilisation By Age
      ticked=params[:utilisation_by_age_group]
      session[:report][:utilisation_by_age_group] = ticked
      if ( ticked )
        agerange_field="dbo.agerange_gms(p.date_of_birth,c.date_service)"
        query = Query.find_by_sql([
          "select #{agerange_field} agerange, count(c.id) count\n"+
          "from claims c left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and s.is_a_entry_service = 1\n"+          
          "   and #{filter}\n"+
          "group by #{agerange_field}\n"+
          "order by 1\n",
          @criteria.start_date, @criteria.end_date, @criteria.programme_id])
    
        @results << { :title => 'Utilisation by Age - Group', :partial_name => 'barchart', 
                        :options => { },
                        :ss => query.map { |r| [ r.agerange, r.count.to_i ] } }
      end
      
      # Utilisation By Age 10y band
      ticked=params[:utilisation_by_age_10y]
      session[:report][:utilisation_by_age_10y] = ticked
      if ( ticked )
        agerange_field="dbo.agerange_10y(p.date_of_birth,c.date_service)"
        query = Query.find_by_sql([
          "select #{agerange_field} agerange, count(c.id) count\n"+
          "from claims c left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and s.is_a_entry_service = 1\n"+          
          "   and #{filter}\n"+
          "group by #{agerange_field}\n"+
          "order by 1\n",
          @criteria.start_date, @criteria.end_date, @criteria.programme_id])
    
        @results << { :title => 'Utilisation by Age - 10y Bands', :partial_name => 'barchart', 
                        :options => { },
                        :ss => query.map { |r| [ r.agerange, r.count.to_i ] } }
      end
      
      ticked=params[:utilisation_by_age_year]
      session[:report][:utilisation_by_age_year] = ticked
      if ( ticked )
        agerange_field="dbo.age(p.date_of_birth,c.date_service)"
        query = Query.find_by_sql([
          "select #{agerange_field} agerange, count(c.id) count\n"+
          "from claims c left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and s.is_a_entry_service = 1\n"+          
          "   and #{filter}\n"+
          "group by #{agerange_field}\n"+
          "order by 1\n",
          @criteria.start_date, @criteria.end_date, @criteria.programme_id])
    
        @results << { :title => 'Utilisation by Age - Year', :partial_name => 'barchart', 
                        :options => { },
                        :ss => query.map { |r| [ r.agerange, r.count.to_i ] } }
      end
  
      ticked=params[:utilisation_by_age_month]
      session[:report][:utilisation_by_age_month] = ticked
      if ( ticked )
        agerange_field="dbo.ageym(p.date_of_birth,c.date_service)"
        query = Query.find_by_sql([
          "select #{agerange_field} agerange, gen.description gender, count(c.id) count\n"+
          "from claims c left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "    left join genders gen on gen.id = p.gender_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and s.is_a_entry_service = 1\n"+          
          "   and #{filter}\n"+
          "group by #{agerange_field}, gen.description\n"+
          "order by 1,2\n",
          @criteria.start_date, @criteria.end_date, @criteria.programme_id])
        ss=merge_rcv_ss(query,'agerange','gender','count');
        @results << { :title => 'Utilisation by Age - Year/Month - Gender', :partial_name => 'spreadsheet', 
                        :options => { },
                        :ss => ss  }
      end
  
  
      # Utilisation By Gender
      ticked=params[:utilisation_by_gender]
      session[:report][:utilisation_by_gender] = ticked
      if ( ticked )
        query = Query.find_by_sql([
          "select gen.description, count(c.id) count\n"+
          "from claims c left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "    left join genders gen on gen.id = p.gender_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and s.is_a_entry_service = 1\n"+          
          "   and #{filter}\n"+
          "group by gen.description\n"+
          "order by 2 desc\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
          # Convert Query into array hashes. 
          
        @results << { :title => 'Utilisation by Gender', :partial_name => 'barchart', 
                        :options => { },
                        :ss => query.map { |r| [ r.description, r.count.to_i ] } }
      end
  
      # Utilisation By Quintile
      if ( params[:utilisation_by_quintile])
        session[:report][:utilisation_by_quintile] = true
        query = Query.find_by_sql([
          "select p.quintile, count(c.id) count\n"+
          "from claims c left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and s.is_a_entry_service = 1\n"+          
          "   and #{filter}\n"+
          "group by p.quintile\n"+
          "order by 1 desc\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
          # Convert Query into array hashes. 
          
        @results << { :title => 'Utilisation by Quintile', :partial_name => 'barchart', 
                        :options => { },
                         :ss => query.map { |r| [ r.quintile, r.count.to_i ] } }
      end       
      
      # Utilisation By Gender
      ticked=params[:utilisation_by_needs]
      session[:report][:utilisation_by_needs] = ticked
      if ( ticked )
        query = Query.find_by_sql([
          "select dbo.maoripi(p.ethnicity_id) maoripi, dbo.dep5(p.quintile) dep5, count(c.id) count\n"+
          "from claims c left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and s.is_a_entry_service = 1\n"+          
          "   and #{filter}\n"+
          "group by dbo.maoripi(p.ethnicity_id), dbo.dep5(p.quintile)\n"+
          "order by 2 desc,1\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
          # Convert Query into array hashes. 
          
        @results << { :title => 'Utilisation by Needs', :partial_name => 'barchart', 
                        :options => { },
                        :ss => query.map { |r| [ "#{r.maoripi} #{r.dep5}", r.count.to_i ] } }
      end
      
      

      # Utilisation By Service
      ticked=params[:patients_utilising_service]
      session[:report][:patients_utilising_service] = ticked
      if ( ticked )
        query = Query.find_by_sql([
          "select f.description, count(distinct c.patient_id) count\n"+
          "from claims c\n"+
          "  left join fee_schedules f on f.id = c.fee_schedule_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and #{filter}\n"+
          "group by f.description\n"+
          "order by 2 desc\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
          # Convert Query into array hashes. 
          
        @results << { :title => 'Patients using each service', :partial_name => 'barchart', 
                        :options => { :total => false }, :note => '# patients',
                        :ss => query.map { |r| [ r.description, r.count.to_i ] } }    
      end                
      
      # Utilisation By Service
      ticked=params[:patients_utilising_by_gender_dep_eth_age]
      session[:report][:patients_utilising_by_gender_dep_eth_age] = ticked
      if ( ticked )
        query = Query.find_by_sql([
          "select p.gender_id gender,dbo.dep5(p.quintile) dep,e.ethnicity_cvdr ethnicity,e.order_by_cvdr,\n"+
          "    dbo.agerange_pmp(p.date_of_birth,c.date_service) age, count(distinct c.patient_id) count\n"+
          "from claims c\n"+
          "  join patients p on p.id = c.patient_id\n"+
          "  left join ethnicities e on e.id = IsNull(p.ethnicity_id,54)\n"+
          "  left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and #{filter}\n"+
          "   and p.gender_id <> ' '\n"+
          "   and p.date_of_birth is not null\n"+
          "   and s.is_a_declined_service = 0 \n"+
          "   and s.is_a_dnr_service = 0 \n"+
          "group by p.gender_id, dbo.dep5(p.quintile), e.ethnicity_cvdr, e.order_by_cvdr, dbo.agerange_pmp(p.date_of_birth,c.date_service)\n"+
          "order by 1 desc, 2, e.order_by_cvdr, 5",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
           
        ss = query.map { |r| [ r.gender, r.dep, r.ethnicity, r.age, r.count ] }     
          
        @results << { :title => 'Patients utilising service', :partial_name => 'table', 
                        :options => { :header => false }, :note => '# patients',
                        :ss => ss }    
      end
      
      #  Services by ethnicity
      ticked=params[:services_by_ethnicity]
      session[:report][:services_by_ethnicity] = ticked
      if ( ticked )
        query = Query.find_by_sql([
          "select s.description service, e1.description ethnicity,e1.id,s.id, count(*) count\n"+
          "from claims c\n"+
          "  join patients p on p.id = c.patient_id\n"+
          "  left join ethnicities e on e.id = IsNull(p.ethnicity_id,54)\n"+
          "  left join level1_ethnicities e1 on e1.id = e.level1_ethnicity_id \n"+
          "  left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and #{filter}\n"+
          "group by s.description, e1.description,e1.id,s.id\n"+
          "order by e1.id, s.id\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
           
        ss = merge_rcv_ss( query, 'ethnicity', 'service',  'count' )
          
        @results << { :title => 'Services by ethnicity', :partial_name => 'spreadsheet', 
                        :options => { :header => true }, :note => nil,
                        :ss => ss }    
      end         
  
      # Diabetes Dataset
      ticked=params[:diabetes_dataset]
      session[:report][:diabetes_dataset] = ticked
      if ( ticked )
         # Build up ethnicity list, so dont miss any columns if 0, and get the order right
         query = Query.find_by_sql([        
           "select distinct order_by_diab, ethnicity_diab ethnicity, 0 count\n"+
           "from ethnicities\n"+
           "order by order_by_diab\n"]);
          ss=merge_rhv_ss(query,'ethnicity','Type 1 Diabetes','count');
           
          # Ethnicity by Type 1 Diabetes 
          query = run_diab_query("#{filter} and d.diab_type_of_diabetes = 'Type 1'")
          ss=merge_rhv_ss(query,'ethnicity','Type 1 Diabetes','count',ss);
    
          # Ethnicity by Type 2 Diabetes 
          query = run_diab_query("#{filter} and d.diab_type_of_diabetes = 'Type 2'")
          ss=merge_rhv_ss(query,'ethnicity','Type 2 Diabetes','count',ss);

          # Add Other Diabetes Column. Then fill in from total=diab1-diab2
          ss[0] << 'Other/Unknown';
          ss[1..-1].each { |e| e << 0 }
          
          # Total
          query = run_diab_query(filter)
          ss=merge_rhv_ss(query,'ethnicity','Total Assessments','count',ss);
          
          # Calculate  "Other Diabetes" from Total
          total_diabetes = 0
          ss[1..-1].each { |e| e[3] = e[4] - e[2] - e[1]; total_diabetes += e[4] }
          total_diabetes = 1 if  total_diabetes < 1  # stop div by 0
          
          # Add/Calculate % Total Column
          ss[0] << '% Total'
          ss[1..-1].each { |e| e <<  ( (e[4] * 100.0) / total_diabetes ).to_i }
          
          # Retinal Screen in the last 2 years. #  
          query = run_diab_query("#{filter} and d.diab_type_of_diabetes = 'Type 2' and datediff(yyyy,d.retind_date_last_retinal_screening,c.date_service) between 0 and 2")
          ss=merge_rhv_ss(query,'ethnicity','Retinal Screen last 2yrs','count',ss);

          # Add/Calculate % Retinal Screen
          ss[0] << '% Retinal Screen'
          ss[1..-1].each { |e| e <<  ( e[4] > 0 ? ( (e[6] * 100.0) / e[4] ).to_i : 0 ) }
    
          # Ethnicity by Hba1c Recorded
          # query = run_diab_query("#{filter} and d.hba1c_hba1c > 0.00")
          # ss=merge_rhv_ss(query,'ethnicity','HBA1c Recorded','count',ss);
    
          # Ethnicity by Hba1c > 7.0
          query = run_diab_query("#{filter} and d.hba1c_hba1c >= 7.00  and d.hba1c_hba1c < 8.00")
          ss=merge_rhv_ss(query,'ethnicity','HBA1c >= 7.0 .. <8','count',ss);
    
          # Ethnicity by Hba1c > 8.0
          query = run_diab_query("#{filter} and d.hba1c_hba1c >= 8.00")
          ss=merge_rhv_ss(query,'ethnicity','HBA1c >= 8.0','count',ss);
    
          # Ethnicity by Smoking History
          query = run_diab_query("#{filter} and d.smok_smoking_history like 'Yes%'")
          ss=merge_rhv_ss(query,'ethnicity','Current Smoker','count',ss);
    
    
          # Ethnicity by Ace Inhibitor
          query = run_diab_query("#{filter} and d.acei_ace_inhibitor like 'Yes%'")
          ss=merge_rhv_ss(query,'ethnicity','ACE Inhibitor','count',ss);
    
          # Ethnicity by total cholesterol Recorded
          query = run_diab_query("#{filter} and d.tc_total_cholesterol > 0.00")
          ss=merge_rhv_ss(query,'ethnicity','Total Chol Recorded','count',ss);
    
    
          # Ethnicity by total cholesterol > 9.0
          query = run_diab_query("#{filter} and d.tc_total_cholesterol > 9.00")
          ss=merge_rhv_ss(query,'ethnicity','Total Chol > 9.0','count',ss);
    
          # Ethnicity by Statin
          query = run_diab_query("#{filter} and d.statin_statin like 'Yes%'")
          ss=merge_rhv_ss(query,'ethnicity','Statin','count',ss);
          
    
          @results << { :title => 'Diabetes Dataset', :partial_name => 'spreadsheet', 
                          :options => { :ctotal => false,:transpose => true },
                          :ss =>  ss }
        
      end
  
      # CVDR Data
      ticked=params[:cvdr_dataset]
      session[:report][:cvdr_dataset] = ticked
      if ( ticked )
        # Get the population
        query_eligiable = Query.find_by_sql([
          "select e.order_by_cvdr orderby, e.ethnicity_cvdr ethnicity, count(p.id) count,  sum(dbo.cvd_eligible_noagelimit(p.date_of_birth,p.gender_id,p.ethnicity_id, ? )) eligiable\n"+
          "from patients p \n"+
          " left join ethnicities e on e.id = IsNull(p.ethnicity_id,#{Ethnicity::OTHER})\n"+
          "where p.organisation_id is not null\n"+
          "group by e.order_by_cvdr, e.ethnicity_cvdr\n"+
          "order by 1\n",@criteria.end_date] )

        
         ss=merge_rhv_ss(query_eligiable,'ethnicity','Enrolled population of PHO','count');
         ss=merge_rhv_ss(query_eligiable,'ethnicity','Number eligiable for risk assessment','eligiable',ss);

         
         query=run_cvdr_risk_assess_query(filter);
         # Get # Screened
         ss=merge_rhv_ss(query,'ethnicity','Total patients screened','count',ss);
         
         
         # Add a column for the to be calculated, percentage
         ss.each { |e| e << 0 }
         ss[0][-1] = 'Percentage of eligible population'
         
         # Some filters for the below. Queries
         noCVD = "(( d.angi_angina_ami is null  or d.angi_angina_ami like 'No%' ) and\n" + 
                   "( d.tia_stroke_tia is null  or d.tia_stroke_tia like 'No%' ) and\n" + 
                   "( d.pvd_peripheral_vessel_disease is null  or d.pvd_peripheral_vessel_disease like 'No%' ) and\n" + 
                   "( d.atfi_atrial_fibrillation is null  or d.atfi_atrial_fibrillation like 'No%' ) and\n" + 
                   "( d.mets_diagnosed_metabolic_syndrome is null  or d.mets_diagnosed_metabolic_syndrome like 'No%' ) and\n" +  
                   "( d.gld_genetic_lipid_disorder is null  or d.gld_genetic_lipid_disorder like 'No%' ))\n"
          
          noDIAB = "( d.diab_type_of_diabetes is null  or d.diab_type_of_diabetes like 'No%' )\n"
          
          lowRISK = "( d.cvdr_cvd_risk < 10.0 )"
          mediumRISK = "( d.cvdr_cvd_risk >= 10.0 and d.cvdr_cvd_risk < 15.0 )"
          highRISK = "( d.cvdr_cvd_risk >= 15.0 )"
          
         # Run the specific queries.
         query=run_cvdr_risk_assess_query("#{filter} and (not #{noCVD})");
         ss=merge_rhv_ss(query,'ethnicity','... with Existing CVD','count',ss);
         
         query=run_cvdr_risk_assess_query("#{filter} and (not #{noDIAB})");
         ss=merge_rhv_ss(query,'ethnicity','... with Diabetes','count',ss);
         
         query=run_cvdr_risk_assess_query("#{filter} and (not #{noDIAB} and not #{noCVD})");
         ss=merge_rhv_ss(query,'ethnicity','... with Diabetes+CVD ','count',ss);
         
         query=run_cvdr_risk_assess_query("#{filter} and (#{noDIAB} and  #{noCVD})");
         ss=merge_rhv_ss(query,'ethnicity','... without Diabetes/CVD ','count',ss);
         
         ss=transpose_ss(ss)
         
         # TRANSPOSED!!.  Ethnicities Across top row
         # Manually Add Total Column
         ss[0] << 'Total'
         ss[1,ss.length].each do |r|
           r << r[1,r.length].inject(0) { |val,e| val += e }
         end
         # Calculate % eligible popn screened:
         # Index 0=heading, 1=enrolled, 2=elig, 3=screened, 4=perage
         c=1
         while ( c < ss[4].length )
           ss[4][c] = "#{(ss[3][c]*100.0 / ss[2][c]).round.to_s}%"  if ss[2][c] > 0
           c += 1;
         end
         
         @results << { :title => 'CVDR Assessment Breakdown', :partial_name => 'spreadsheet', 
                          :options => { :ctotal => false, :rtotal => false },
                          :note => 'Eligible population is Maori/PI/Indian (Male 35+,Female 45+), Other (Male 45+,Female 55+), No upper age limit',
                          :ss =>  ss }
                          
         # Details of High Needs and Managment Plans
         # Get # High Risk Patients
         query=run_cvdr_risk_assess_query("( #{filter} and d.cvdr_cvd_risk >= 15 )");
         ss=merge_rhv_ss(query,'ethnicity','High Risk Patients (CVDR >= 15)','count');
         
         query = Query.find_by_sql([
           "select e.order_by_cvdr orderby, e.ethnicity_cvdr ethnicity, count(distinct c.patient_id) count\n"+
           "from claims c\n"+
           "  left join claims_data d on d.id = c.id\n"+
           "  left join patients p on p.id = c.patient_id\n"+
           "  left join ethnicities e on e.id = IsNull(p.ethnicity_id,#{Ethnicity::OTHER})\n"+
           "where c.date_service >= ?  and c.date_service <= ?\n"+
           " and c.programme_id = ?\n"+
           " and c.claim_status_id <= 6\n"+
           " and c.fee_schedule_id in ( 21, 22, 23, 25, 26 )\n"+
           " and exists ( select 1 \n"+
           "    from claims xc \n"+
           "       left join claims_data xd on xd.id = xc.id\n"+
           "     where xc.patient_id = c.patient_id\n"+
           "       and xc.date_service >= '20080101'\n"+
           "       and xc.date_service <= c.date_service\n"+
           "       and xc.programme_id = c.programme_id\n"+
           "       and xc.claim_status_id <= 6\n"+
           "       and xd.cvdr_cvd_risk >= 15 )\n"+
           "group by e.order_by_cvdr, e.ethnicity_cvdr\n"+
           "order by 1\n",
            @criteria.start_date, @criteria.end_date, @criteria.programme_id])
         ss=merge_rhv_ss(query,'ethnicity','Patients Receiving Managment Plan','count',ss);

         @results << { :title => 'CVDR High Risk Breakdown', :partial_name => 'spreadsheet', 
                          :options => { :ctotal => false, :rtotal => true, :transpose => true },
                          :ss =>  ss }
                          
         # Risk Levels
         query=run_cvdr_risk_assess_query("( #{filter} and #{lowRISK} )");
         ss=merge_rhv_ss(query,'ethnicity','Total  <10','count');
         bar=merge_hv_nv(query,'Total  <10','count')
         
         query=run_cvdr_risk_assess_query("( #{filter} and #{mediumRISK} )");
         ss=merge_rhv_ss(query,'ethnicity','Total 10..<15','count',ss);
         bar=merge_hv_nv(query,'Total 10..<15','count',bar)
         
         query=run_cvdr_risk_assess_query("( #{filter} and #{highRISK} )");
         ss=merge_rhv_ss(query,'ethnicity','Total 15+','count',ss);
         bar=merge_hv_nv(query,'Total 15+','count',bar)
    
         query=run_cvdr_risk_assess_query("( #{filter} and #{lowRISK} and not #{noDIAB} )");
         ss=merge_rhv_ss(query,'ethnicity','Diabetes <10','count',ss);
         query=run_cvdr_risk_assess_query("( #{filter} and #{mediumRISK} and not #{noDIAB} )");
         ss=merge_rhv_ss(query,'ethnicity','Diabetes 10..<15','count',ss);
         query=run_cvdr_risk_assess_query("( #{filter} and #{highRISK} and not #{noDIAB} )");
         ss=merge_rhv_ss(query,'ethnicity','Diabetes 15+','count',ss);
    
         @results << { :title => 'Assessments by Risk Level', :partial_name => 'barchart', 
                         :options => { },
                         :ss =>  bar }
         
         ss=transpose_ss(ss)
         
         @results << { :title => 'Risk % Level  Breakdown', :partial_name => 'spreadsheet', 
                          :options => { :ctotal => false, :rtotal => true },
                          :ss =>  ss }

         # Managment Targets
#         ss = [ ['','Assessments','Aspirin','Statin','Controlled BP']]
#         
#         veryHighRISK = "( d.cvdr_cvd_risk >= 35.0 )"
#         onAspirin = "( aspi_aspirin like 'y%' )"
#         onStatin = "( statin_statin like 'y%' )"
#         controlledBP = "( sbp_systolic_blood_pressure  <= 140 and dbp_diastolic_blood_pressure  <= 90 )"
#         goodGlycaemic = "( hba1c_hba1c < 8 )"
#         
#         ss << ['Very High Risk (>= 35)']
#         ss[-1] << run_cvdr_count("( #{veryHighRISK} )")  # Assessments
#         ss[-1] << run_cvdr_count("( #{veryHighRISK} and #{onAspirin})") # Asprin
#         ss[-1] << run_cvdr_count("( #{veryHighRISK} and #{onStatin})") # Statin
#         ss[-1] << run_cvdr_count("( #{veryHighRISK} and #{controlledBP})") # Controlled BP
#         # ss[-1] << run_cvdr_count("( #{veryHighRISK} and #{goodGlycaemic})") # Good Glycaemic Control
#
#         ss << ['High Risk (> 15)']
#         ss[-1] << run_cvdr_count("( #{highRISK} )")  # Assessments
#         ss[-1] << run_cvdr_count("( #{highRISK} and #{onAspirin})") # Asprin
#         ss[-1] << run_cvdr_count("( #{highRISK} and #{onStatin})") # Statin
#         ss[-1] << run_cvdr_count("( #{highRISK} and #{controlledBP})") # Controlled BP
#         # ss[-1] << run_cvdr_count("( #{highRISK} and #{goodGlycaemic})") # Good Glycaemic Control
#         
#         ss << ['Diabetes']
#         ss[-1] << run_cvdr_count("( not #{noDIAB} )")  # Assessments
#         ss[-1] << run_cvdr_count("( not #{noDIAB} and #{onAspirin})") # Asprin
#         ss[-1] << run_cvdr_count("( not #{noDIAB} and #{onStatin})") # Statin
#         ss[-1] << run_cvdr_count("( not #{noDIAB} and #{controlledBP})") # Controlled BP
#         # ss[-1] << run_cvdr_count("( not #{noDIAB} and #{goodGlycaemic})") # Good Glycaemic Control
#         
#         @results << { :title => 'Managment Targets % Level  Breakdown', :partial_name => 'spreadsheet', 
#                          :options => { :total => false },
#                          :ss =>  ss }
      
      
      end
      
      # Care Plus Population Breakdown
      ticked=params[:care_plus_uptake_by_needs]
      session[:report][:care_plus_uptake_by_needs] = ticked
      if ( ticked )
        query = Query.find_by_sql([
          "SELECT dbo.maoripi(p.ethnicity_id) maoripi, dbo.dep5(p.quintile) quintile,\n"+
          "  count(p.id) popn, \n"+
          "  cast((sum(dbo.cplus_eligible(p.date_of_birth, p.gender_id, p.ethnicity_id, p.quintile, cast('#{@criteria.end_date.to_s(:db)}' as datetime) )) / 100) as integer) elig,\n"+
          "  sum(p.is_huhc_holder) huhc,\n"+
          "  sum(p.is_care_plus) cplus\n"+
          "FROM PATIENTS p\n"+
          "where organisation_id is not null\n"+
          "group by dbo.maoripi(p.ethnicity_id), dbo.dep5(p.quintile)\norder by 2,1 desc\n"])
         ss = [['','Population','% Eligible','Eligible','HUHC','Residual','Enrolled','% Uptake']]
         total_popn = 0
         total_elig = 0
         total_huhc = 0
         total_cplus = 0
         query.each do |r|
           # We Want, For Each Group
           # Enrolled Population
           # % Eligible   (# Eligible /Enrolled Population)
           # # Eligible
           # HUHC
           # Residual (# Eligible - HUHC)
           # Enrolled
           # Uptake   (Enrolled/Residual)
           total_popn += r.popn
           total_elig += r.elig
           total_huhc += r.huhc
           total_cplus += r.cplus
           
           
           perage_elig = "%.2f" % (( r.elig * 100.00 ) / r.popn) unless r.popn < 1
           residual = r.elig - r.huhc
           uptake = "%.2f" % ( r.cplus * 100.00 / residual ) unless residual == 0
           ss << [ "#{r.maoripi} #{r.quintile}",r.popn,perage_elig,r.elig,r.huhc,residual,r.cplus,uptake  ]
         end
         perage_elig = "%.2f" % (( total_elig * 100.00 ) / total_popn) unless total_popn < 1
         residual = total_elig - total_huhc
         uptake = "%.2f" % ( total_cplus * 100.00 / residual ) unless residual == 0
         ss << [ "TOTAL",total_popn,perage_elig,total_elig,total_huhc,residual,total_cplus,uptake  ]
         @results << { :title => 'Care Plus Uptake By Needs', :partial_name => 'spreadsheet', 
                          :options => { :ctotal => false, :rtotal => false },
                          :ss =>  ss }
       
      end
      # Care Plus Uptake by Practice
      ticked=params[:care_plus_uptake_by_practice]
      session[:report][:care_plus_uptake_by_practice] = ticked
      if ( ticked )
        query = Query.find_by_sql([
          "SELECT p.organisation_id, o.name,\n"+
          "  count(p.id) popn, \n"+
          "  cast((sum(dbo.cplus_eligible(p.date_of_birth, p.gender_id, p.ethnicity_id, p.quintile, cast('#{@criteria.end_date.to_s(:db)}' as datetime) )) / 100) as integer) elig,\n"+
          "  sum(p.is_huhc_holder) huhc,\n"+
          "  sum(p.is_care_plus) cplus\n"+
          "FROM PATIENTS p\n"+
          "  left join organisations o on o.id = p.organisation_id\n"+
          "where organisation_id is not null\n"+
          "group by p.organisation_id, o.name\norder by 2\n"])
         ss = [['','Population','% Eligible','Eligible','HUHC','Residual','Enrolled','% Uptake']]
         query.each do |r|
           # r.huhc could be null # weird 
           rhuhc = 0
           rhuhc = r.huhc.to_i unless r.huhc.blank? 
           perage_elig = "%.2f" % (( r.elig * 100.00 ) / r.popn) unless r.popn < 1
           residual = r.elig - rhuhc
           uptake = "%.2f" % ( r.cplus * 100.00 / residual ) unless residual == 0
           ss << [ r.name,r.popn,perage_elig,r.elig,rhuhc,residual,r.cplus,uptake  ]
           uptake = ""
         end
         @results << { :title => 'Care Plus Uptake By Practice', :partial_name => 'spreadsheet', 
                          :options => { :rtotal => false, :ctotal => false },
                          :ss =>  ss }
       
      end
      
      # B4School extensions
      ticked=params[:b4_school_ex]
      session[:report][:b4_school_ex] = ticked
      if ( ticked )
        
        # Decliners - By Age
        agerange_field="dbo.ageym(p.date_of_birth,c.date_service)"
        query = Query.find_by_sql([
          "select #{agerange_field} agerange, gen.description gender, count(c.id) count\n"+
          "from claims c\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "    left join genders gen on gen.id = p.gender_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and #{filter} and fee_schedule_id = #{FeeSchedule::B4SC_DECLINED}\n"+
          "group by #{agerange_field}, gen.description\n"+
          "order by 1,2\n",
          @criteria.start_date, @criteria.end_date, @criteria.programme_id])
        ss=merge_rcv_ss(query,'agerange','gender','count');
        @results << { :title => 'B4School Decliners by Age - Year/Month - Gender', :partial_name => 'spreadsheet', 
                        :note => '', :options => { },
                        :ss => ss  }        
        

        # Decliners - By Ethnicity
        query = Query.find_by_sql([
          "select IsNull(el1.id,9),el1.description ethnicity, count(c.id) count\n"+
          "from claims c\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "    left join ethnicities eth on eth.id = p.ethnicity_id \n"+
          "      left join level1_ethnicities el1 on el1.id = eth.level1_ethnicity_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and #{filter} and c.fee_schedule_id = #{FeeSchedule::B4SC_DECLINED}\n"+
          "group by IsNull(el1.id,9),el1.description\n"+
          "order by 1\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])

        ss = query.map { |r| [ r.ethnicity, r.count.to_i ] }
        # Convert Query into array hashes. 
        @results << { :title => 'B4School Decliners by Ethnicity', :partial_name => 'barchart', 
                        :note => '', :options => { },
                        :ss => ss }
        
        
        ss = []
        # Number of referrals with reason 
        referral_made_where = ''
        ['chqre_child_heath_q_referral','dentre_dental_referral','growre_growth_measure_referral',  
         'immre_immunisation_referral','pedsref_peds_referral','pedsref2_peds_referral_2',
         'sdqref_sdq_referral','sdqref2_sdq_referral_2','vishr_vision_hearing_referral'].each do |column_name|
          df=DataField.find(:first,:conditions => { :column_name => column_name })
          referral_made_where += " or " if referral_made_where.length > 0 
          referral_made_where += "( d.#{column_name} <> '' and lower(d.#{column_name}) <> 'declined' and lower(d.#{column_name}) <> 'n/a' )"
          query = Query.find_by_sql([
            "select d.#{column_name} description, count(c.id) count\n"+
            "from claims c\n"+
            "  left join claims_data d on d.id = c.id\n"+
            "  left join patients p on p.id = c.patient_id\n"+
            "where c.date_service >= ?  and c.date_service <= ? \n"+
            "   and c.programme_id = ?\n"+
            "   and c.claim_status_id <= 6\n"+
            "   and #{filter}\n"+
            "   and d.#{column_name} <> ''\n"+
            "   and lower(d.#{column_name}) <> 'declined'\n"+
            "   and lower(d.#{column_name}) <> 'n/a'\n"+
            "   and c.fee_schedule_id <> #{FeeSchedule::B4SC_DECLINED}\n"+
            "group by d.#{column_name}\n",
             @criteria.start_date, @criteria.end_date, @criteria.programme_id])
            query.each { |r| ss <<  [ "#{df.label} - #{r.description}", r.count.to_i ] }
        end
        @results << { :title => 'B4School Referrals - Reason', :partial_name => 'barchart', 
                        :options => { },
                        :ss => ss  }

        # Need total # checks.
        query = Query.find_by_sql([
            "select count(c.id) count\n"+
            "from claims c\n"+
            "  left join claims_data d on d.id = c.id\n"+
            "  left join patients p on p.id = c.patient_id\n"+
            "where c.date_service >= ?  and c.date_service <= ? \n"+
            "   and c.programme_id = ?\n"+
            "   and c.claim_status_id <= 6\n"+
            "   and c.fee_schedule_id <> #{FeeSchedule::B4SC_DECLINED}\n"+
            "   and #{filter}\n",
             @criteria.start_date, @criteria.end_date, @criteria.programme_id])
             
        total_nchecks = query[0].count.to_i
        total_nchecks = 1 if total_nchecks <= 0
                        
        # total number of patients with a referrals
        query = Query.find_by_sql([
            "select 'Children Referred' description, count(c.id) count\n"+
            "from claims c\n"+
            "  left join claims_data d on d.id = c.id\n"+
            "  left join patients p on p.id = c.patient_id\n"+
            "where c.date_service >= ?  and c.date_service <= ? \n"+
            "   and c.programme_id = ?\n"+
            "   and c.claim_status_id <= 6\n"+
            "   and #{filter}\n"+
            "   and c.fee_schedule_id <> #{FeeSchedule::B4SC_DECLINED}\n"+
            "   and ( #{referral_made_where} )\n",
             @criteria.start_date, @criteria.end_date, @criteria.programme_id])

        @results << { :title => 'B4School Referrals ', :partial_name => 'barchart', 
                      :note => 'chart as % of checks',
                        :options => { },
                        :ss => query.map { |r| [ r.description, r.count.to_i,
                           ( r.count.to_f * 100.00 / total_nchecks ).to_i ] } }
                           
        # total number of patients were imm devivered or referred

        query = Query.find_by_sql([
            "select 'Immunisations Referred/Vacc ' description, count(c.id) count\n"+
            "from claims c\n"+
            "  left join claims_data d on d.id = c.id\n"+
            "  left join patients p on p.id = c.patient_id\n"+
            "where c.date_service >= ?  and c.date_service <= ? \n"+
            "   and c.programme_id = ?\n"+
            "   and c.claim_status_id <= 6\n"+
            "   and #{filter}\n"+
            "   and c.fee_schedule_id <> #{FeeSchedule::B4SC_DECLINED}\n"+
            "   and (( d.immre_immunisation_referral <> '' and lower(d.immre_immunisation_referral) <> 'declined' ) OR ( lower(d.immvt_immunisation_vacc_today) = 'yes' )) \n",
             @criteria.start_date, @criteria.end_date, @criteria.programme_id])

        @results << { :title => 'B4School Immunisations ', :partial_name => 'barchart', 
                      :note => 'chart as % of checks',
                        :options => { },
                        :ss => query.map { |r| [ r.description, r.count.to_i,
                           ( r.count.to_f * 100.00 / total_nchecks ).to_i ] } }
      end

      # Mental Health (Lifestyle options) extensions
      ticked=params[:lifestyle_options_mh_ex]
      session[:report][:lifestyle_options_mh_ex] = ticked
      if ( ticked )
        # Quality of life.
        [FeeSchedule::PLMH_INITIAL,FeeSchedule::PLMH_OUTCOME ].each do |fs|
          query = Query.find_by_sql([
            "select qolr_quality_of_life_rating description, count(c.id) count\n"+
            "from claims c\n"+
            "  left join claims_data d on d.id = c.id\n"+
            "where c.date_service >= ?  and c.date_service <= ? \n"+
            "   and c.programme_id = ?\n"+
            "   and c.claim_status_id <= 6\n"+
            "   and #{filter}\n"+
            "   and c.fee_schedule_id = #{fs}\n"+
            "   and qolr_quality_of_life_rating <> ''\n"+
            "group by qolr_quality_of_life_rating order by 1\n",
             @criteria.start_date, @criteria.end_date, @criteria.programme_id])
          start_end=(fs==FeeSchedule::PLMH_INITIAL) ? 'start' : 'end'
          @results << { :title => "Lifestyle Options (MH) Quality of life at #{start_end}", :partial_name => 'barchart', 
                        :options => { :total => false },
                        :ss => query.map { |r| [ r.description, r.count.to_i ] } }
        end

        # mhphq9_mhealth_phq_9 at Start/End
        # 800 Initial GP
        # 801 Follow-up GP
        # 802 Final Consultation/Exit
        # 803 Nurse Intervention
        # 804 Psychologist
        # 805 Counsellor
        # 806 Transport
        # 807 Community Service
        # 808 Mental Health Service
        # 809 DNA Session
        # 810 CADS
        # 811 Smoking Cessation
        # 812 Oasis (Gambling)
        # 813 Psychotherapist
        # 817 Outcome
        # 818 Complete
        # 819 In-Complete
        # alter table claims_data alter column mhphq9_mhealth_phq_9 integer;

        ['start','end' ].each do |start_end|
          fee_schedule_filter = "fee_schedule_id in ( 800, 804, 813, 805 )";
          fee_schedule_filter = "fee_schedule_id in ( 802, 817 )" if ( start_end == 'end' )
          query = Query.find_by_sql([
            "select mhphq9_mhealth_phq_9 description, count(c.id) count\n"+
            "from claims c\n"+
            "  left join claims_data d on d.id = c.id\n"+
            "where c.date_service >= ?  and c.date_service <= ? \n"+
            "   and c.programme_id = ?\n"+
            "   and c.claim_status_id <= 6\n"+
            "   and #{filter}\n"+
            "   and #{fee_schedule_filter}\n"+
            "   and mhphq9_mhealth_phq_9 <> ''\n"+
            "group by mhphq9_mhealth_phq_9 order by 1\n",
             @criteria.start_date, @criteria.end_date, @criteria.programme_id])
          @results << { :title => "PHQ9 at #{start_end}", :partial_name => 'barchart', 
                        :options => { :total => false },
                        :ss => query.map { |r| [ r.description, r.count.to_i ] } }
        end

        # alter table claims_data alter column mhk10_mhealth_kessler_10 integer;
        ['start','end' ].each do |start_end|
          fee_schedule_filter = "fee_schedule_id in ( 800, 804, 813, 805 )";
          fee_schedule_filter = "fee_schedule_id in ( 802, 817 )" if ( start_end == 'end' )
          query = Query.find_by_sql([
            "select mhk10_mhealth_kessler_10 description, count(c.id) count\n"+
            "from claims c\n"+
            "  left join claims_data d on d.id = c.id\n"+
            "where c.date_service >= ?  and c.date_service <= ? \n"+
            "   and c.programme_id = ?\n"+
            "   and c.claim_status_id <= 6\n"+
            "   and #{filter}\n"+
            "   and #{fee_schedule_filter}\n"+
            "   and mhk10_mhealth_kessler_10 <> ''\n"+
            "group by mhk10_mhealth_kessler_10 order by 1\n",
             @criteria.start_date, @criteria.end_date, @criteria.programme_id])
          @results << { :title => "Kessler 10 at #{start_end}", :partial_name => 'barchart', 
                        :options => { :total => false },
                        :ss => query.map { |r| [ r.description, r.count.to_i ] } }
        end
                
        
        
        # No of Diagnosese
        ss = [];
        ['mhdx_mhealth_diagnosis','mhdx2_mhealth_diagnosis_2','mhdx3_mhealth_diagnosis_3',
         'mhdx4_mhealth_diagnosis_4','mhdx5_mhealth_diagnosis_5','mhdx6_mhealth_diagnosis_6'].each do |colname|
          query = Query.find_by_sql([
            "select #{colname} description, count(c.id) count\n"+
            "from claims c\n"+
            "  left join claims_data d on d.id = c.id\n"+
            "where c.date_service >= ?  and c.date_service <= ? \n"+
            "   and c.programme_id = ?\n"+
            "   and c.claim_status_id <= 6\n"+
            "   and #{filter}\n"+
            "   and c.fee_schedule_id = #{FeeSchedule::PLMH_INITIAL}\n"+
            "   and #{colname} <> ''\n"+
            "group by #{colname} order by 1\n",
             @criteria.start_date, @criteria.end_date, @criteria.programme_id])
            ss = merge_rv_nv(query,'description','count',ss)
        end       

        @results << { :title => 'Lifestyle Options (MH) Diagnosis', :partial_name => 'barchart', 
                       :options => { :total => false },
                        :ss => ss }
        
      end
      
      ticked=params[:smoking_atm_ex]
      session[:report][:smoking_atm_ex] = ticked
      if ( ticked )
        query = Query.find_by_sql([
          "select d.smready_smoking_readiness_quit readiness, count(c.id) count\n"+
          "from claims c\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and d.smready_smoking_readiness_quit is not null\n"+
          "   and #{filter}\n"+
          "group by d.smready_smoking_readiness_quit\n"+
          "order by 1\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])

        ss = query.map { |r| [ r.readiness, r.count.to_i ] }
        # Convert Query into array hashes. 
        @results << { :title => 'Readiness to Quit', :partial_name => 'barchart', 
                        :note => '', :options => { },
                        :ss => ss }

        query = Query.find_by_sql([
          "select d.smref_smoking_action_referral action, count(c.id) count\n"+
          "from claims c\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and d.smref_smoking_action_referral is not null\n"+
          "   and #{filter}\n"+
          "group by d.smref_smoking_action_referral\n"+
          "order by 1\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])

        ss = query.map { |r| [ r.action, r.count.to_i ] }
        # Convert Query into array hashes. 
        @results << { :title => 'Smoking Action/Referral', :partial_name => 'barchart', 
                        :note => '', :options => { },
                        :ss => ss }      


        query = Query.find_by_sql([
          "select top 11 isnull(d.smpatrx_smoking_patch_rx,'') + ' ' + isnull(d.smgumrx_smoking_gum_rx,'')+ ' ' + isnull(d.smothrx_smoking_other_rx,'') rx, count(c.id) count\n"+
          "from claims c\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and d.smref_smoking_action_referral is not null\n"+
          "   and #{filter}\n"+
          "group by smpatrx_smoking_patch_rx,smgumrx_smoking_gum_rx,smothrx_smoking_other_rx\n"+
          "order by 2 desc, 1\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
        query.shift # Remove 1st element as blank 
        ss = query.map { |r| [ r.rx.strip, r.count.to_i ] }
        # Convert Query into array hashes. 
        @results << { :title => 'Top 10 Rx', :partial_name => 'barchart', 
                        :note => '', :options => { :total => false },
                        :ss => ss }      
      end
  
      ticked=params[:get_checked_by_ethnicity]
      session[:report][:get_checked_by_ethnicity] = ticked
      if ( ticked )
        query = Query.find_by_sql([
          "select  e1.description ethnicity,e1.id, count(distinct p.id) count\n"+
          "from claims c\n"+
          "  join patients p on p.id = c.patient_id\n"+
          "  left join ethnicities e on e.id = IsNull(p.ethnicity_id,54)\n"+
          "  left join level1_ethnicities e1 on e1.id = e.level1_ethnicity_id \n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and #{filter}\n"+
          "group by e1.description,e1.id\n"+
          "order by e1.id\n",
           @criteria.start_date, @criteria.end_date, Programme::DIAB])
           
        ss = merge_rhv_ss( query, 'ethnicity', 'GetChecked', 'count' )
        
        diabetes_types = [ 'Type 1', 'Type 2' ]
        
        diabetes_types.each do |dtype|
        
        
          query = Query.find_by_sql([
            "select  e1.description ethnicity,e1.id, count(distinct p.id) count\n"+
            "from claims c\n"+
            "  left join claims_data d on d.id = c.id\n"+
            "  join patients p on p.id = c.patient_id\n"+
            "  left join ethnicities e on e.id = IsNull(p.ethnicity_id,54)\n"+
            "  left join level1_ethnicities e1 on e1.id = e.level1_ethnicity_id \n"+
            "where c.date_service >= ?  and c.date_service <= ? \n"+
            "   and c.programme_id = ?\n"+
            "   and c.claim_status_id <= 6\n"+
            "   and d.diab_type_of_diabetes like ?\n"+
            "   and #{filter}\n"+
            "group by e1.description,e1.id\n"+
            "order by e1.id\n",
             @criteria.start_date, @criteria.end_date, Programme::DIAB, dtype.downcase + '%'])
          
            ss = merge_rhv_ss( query, 'ethnicity', dtype, 'count', ss )
         end
          
        @results << { :title => 'Patients receiving Get Checked by Ethnicity', :partial_name => 'spreadsheet', 
                        :options => { :header => true, :rtotal => false }, :note => 'this is patients, not number of GetChecks',
                        :ss => ss }    

        
        
        
      end
      
      ticked=params[:podiatry_ex]
      session[:report][:podiatry_ex] = ticked
      if ( ticked )

        # Poidatary referrals by ethnicity
        query = Query.find_by_sql([
          "select e1.description ethnicity,e1.id, d.podref_podiatary_referral referral, count(*) count\n"+
          "from claims c\n"+
          "  join patients p on p.id = c.patient_id\n"+
          "  left join ethnicities e on e.id = IsNull(p.ethnicity_id,54)\n"+
          "  left join level1_ethnicities e1 on e1.id = e.level1_ethnicity_id \n"+
          "  left join claims_data d on d.id = c.id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and d.podref_podiatary_referral <> ''\n"+
          "   and #{filter}\n"+
          "group by e1.description,e1.id, d.podref_podiatary_referral\n"+
          "order by e1.id,d.podref_podiatary_referral\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
           
        ss = merge_rcv_ss( query, 'ethnicity', 'referral',  'count' )

          
        query = Query.find_by_sql([
          "select e1.description ethnicity,e1.id, d.podref_podiatary_referral2 referral, count(*) count\n"+
          "from claims c\n"+
          "  join patients p on p.id = c.patient_id\n"+
          "  left join ethnicities e on e.id = IsNull(p.ethnicity_id,54)\n"+
          "  left join level1_ethnicities e1 on e1.id = e.level1_ethnicity_id \n"+
          "  left join claims_data d on d.id = c.id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and d.podref_podiatary_referral2 <> ''\n"+
          "   and #{filter}\n"+
          "group by e1.description,e1.id, d.podref_podiatary_referral2\n"+
          "order by e1.id,d.podref_podiatary_referral2\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
          
        ss = merge_rcv_ss( query, 'ethnicity', 'referral',  'count', ss )
          
        @results << { :title => 'Podiatrists (on referring) by ethnicity', :partial_name => 'spreadsheet', 
                        :options => { :header => true }, :note => nil,
                        :ss => ss }
                        

        # Set the Poidatary First Assessment's By Risk level (if blank) from any available data
        ClaimsData.update_all(
               # Update with 1st Referral that has a rfiskc_foot_risk_category
               "rfiskc_foot_risk_category = \n"+
               "( select top 1 ref2d.rfiskc_foot_risk_category\n"+
               "  from claims inv\n"+
               "   left join claims ref2 on ref2.patient_id = inv.patient_id \n"+
               "                and ref2.programme_id = 23\n"+
               "    left join claims_data ref2d on ref2d.id = ref2.id\n"+
               "  where inv.id = claims_data.id\n"+
               "    and ref2d.rfiskc_foot_risk_category <> '' \n"+
               "  order by inv.invoice_date\n"+
               "  )",
               # Only do this for Assessments with a referral has a rfiskc_foot_risk_category
               "id in ( \n"+
               "select distinct c.id\n"+
               " from claims c\n"+
               "  left join claims_data d on d.id = c.id\n"+
               "   left join claims ref on ref.patient_id = c.patient_id \n"+
               "                and ref.programme_id = 23\n"+
               "    left join claims_data refd on refd.id = ref.id\n"+
               " where c.programme_id = 23 \n"+
               "   and ( c.fee_schedule_id = 2301 or c.fee_schedule_id = 2304)\n"+
               "   and ( d.rfiskc_foot_risk_category is null or d.rfiskc_foot_risk_category = '')\n"+
               "   and ( refd.rfiskc_foot_risk_category <> '')\n"+
               ")" )
  
        # Poidatary First Assessment's By Risk level
        query = Query.find_by_sql([
          "select e1.description ethnicity,e1.id, d.rfiskc_foot_risk_category risk, count(*) count\n"+
          "from claims c\n"+
          "  join patients p on p.id = c.patient_id\n"+
          "  left join ethnicities e on e.id = IsNull(p.ethnicity_id,54)\n"+
          "  left join level1_ethnicities e1 on e1.id = e.level1_ethnicity_id \n"+
          "  left join claims_data d on d.id = c.id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and ( c.fee_schedule_id = ? or c.fee_schedule_id = ? )\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and #{filter}\n"+
          "group by e1.description,e1.id, d.rfiskc_foot_risk_category\n"+
          "order by e1.id,d.rfiskc_foot_risk_category\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id,
           FeeSchedule::PODA_FIRST_ASSESSMENT, FeeSchedule::PODA_SINGLE_VISIT ])
          
        ss = merge_rcv_ss( query, 'ethnicity', 'risk',  'count' )
          
        @results << { :title => 'Podiatry Risk Levels by ethnicity', :partial_name => 'spreadsheet', 
                        :options => { :header => true }, :note => 'Ist Assessment+Single Visit',
                        :ss => ss }
        
        
      end
      
      
      ticked=params[:post_natal_adjustment_ex]
      session[:report][:post_natal_adjustment_ex] = ticked
      if ( ticked )
        # No of Referrals
        ss = [];
        ['pnrt_pnap_referral_to','pnrt2_pnap_referral_to_2'].each do |colname|
          query = Query.find_by_sql([
            "select #{colname} description, count(c.id) count\n"+
            "from claims c\n"+
            "  left join claims_data d on d.id = c.id\n"+
            "where c.date_service >= ?  and c.date_service <= ? \n"+
            "   and c.programme_id = ?\n"+
            "   and c.claim_status_id <= 6\n"+
            "   and #{filter}\n"+
            "   and c.fee_schedule_id = #{FeeSchedule::PNAP_END_OF_CARE}\n"+
            "   and #{colname} <> ''\n"+
            "group by #{colname} order by 1\n",
             @criteria.start_date, @criteria.end_date, @criteria.programme_id])
            ss = merge_rv_nv(query,'description','count',ss)
        end       

        @results << { :title => 'Post-natal Adjustment Referrals', :partial_name => 'barchart', 
                       :options => { :total => false },
                        :ss => ss }
                        
        # No of Sessions, etc 
        ss = [['','Count']]
        ['nosess_number_of_sessions','noga_number_of_group_attendances','nopga_number_of_partner_group_attendances'].each do |colname|
          query = Query.find_by_sql([
              "select sum(d.#{colname}) count\n"+
              "from claims c\n"+
              "  left join claims_data d on d.id = c.id\n"+
              "where c.date_service >= ?  and c.date_service <= ? \n"+
              "   and c.programme_id = ?\n"+
              "   and c.claim_status_id <= 6\n"+
              "   and c.fee_schedule_id = #{FeeSchedule::PNAP_END_OF_CARE}\n"+
              "   and #{filter}\n",
               @criteria.start_date, @criteria.end_date, @criteria.programme_id])
          ss <<  [ colname.titlecase.sub(/[^ ]* /,''), query[0].count.to_i ]
        end
        @results << { :title => 'Post-natal Adjustment Sessions', :partial_name => 'spreadsheet', 
                        :options => { :rtotal => false, :ctotal => false },
                        :ss => ss  }
                   

        query = Query.find_by_sql([
          "select (d_ref.epdssc_epds_score-d.epdssc_epds_score) score, count(c.id) count\n"+
          "from claims c\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "  left join claims c_ref on c_ref.patient_id = c.patient_id and c_ref.programme_id = c.programme_id and c_ref.invoice_date <= c.invoice_date \n"+
          "  left join claims_data d_ref on d_ref.id = c_ref.id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and c.fee_schedule_id = #{FeeSchedule::PNAP_END_OF_CARE}\n"+
          "   and c_ref.fee_schedule_id = #{FeeSchedule::PNAP_REFERRAL}\n"+
          "   and d.epdssc_epds_score is not null\n"+
          "   and d_ref.epdssc_epds_score is not null\n"+
          "   and #{filter}\n"+
          "group by (d_ref.epdssc_epds_score-d.epdssc_epds_score)\n"+
          "order by 1\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])

        ss = query.map { |r| [ r.score, r.count.to_i ] }
        # Convert Query into array hashes. 
        @results << { :title => 'EPDS Scoring Decrease', :partial_name => 'barchart', 
                        :note => '', :options => { :total => false },
                        :ss => ss }                       
                   
      end
      

      # Utilisation By Practice
      ticked=params[:utilisation_by_practice]
      session[:report][:utilisation_by_practice] = ticked
      if ( ticked )
        query = Query.find_by_sql([
          "select o.id organisation_id, o.name, count(c.id) count, IsNull(o.est_no_patients,0) popn,\n"+
          "( CASE o.est_no_patients WHEN NULL THEN 0 WHEN 0  THEN 0 ELSE (count(c.id)*100.00) / o.est_no_patients  END ) perage\n"+
          "from claims c left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "  left join organisations o on o.id = c.cost_organisation_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and s.is_a_entry_service = 1\n"+          
          # "   and #{filter}\n"+ # Dont add in filter as always for all practices.
          "group by o.id, o.name, o.est_no_patients\n"+
          "order by 5 desc\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
          # Convert Query into array hashes. 
        ss = query.map { |r| [ r.name, r.count.to_s+'/'+(r.popn/1000.00).round.to_s, 
                                   ((r.perage.to_f)*100).to_i/100.00, r.organisation_id.to_i ] }
        # Make it anonomous, only show top 2/3 rds 
        unless @criteria.organisation_id.blank?     
          ss_slice_len=ss.length * 2 / 3 + 1    
          ss.each_with_index do |e,i|
            if e[3] != @criteria.organisation_id.to_i
              e[0] = '- -'
              e[1] = '-/-'
            else
              ss_slice_len=i+1 if i >= ss_slice_len # If practice not in top 2/3, show it at the bottom
            end
          end
          ss=ss.slice(0,ss_slice_len)
        end
      
          
        @results << { :title => 'Utilisation by Practice', :partial_name => 'barchart', 
                      :note => 'chart as % of population, #/popn (000\'s)',
                        :options => { :row_count => true },
                        :ss => ss }                   
      end
      
      # Utilisation By Service Provider
      ticked=params[:utilisation_by_service_provider]
      session[:report][:utilisation_by_service_provider] = ticked
      if ( ticked )
        query = Query.find_by_sql([
          "select p.name, count(c.id) count \n"+
          "from claims c left join fee_schedules s on s.id = c.fee_schedule_id\n"+
          "  left join providers p on p.id = c.service_provider_id \n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and s.is_a_entry_service = 1\n"+          
          "   and #{filter}\n"+
          "group by p.name\n"+
          "order by 2 desc\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
          # Convert Query into array hashes. 
          
        @results << { :title => 'Utilisation by Service Provider', :partial_name => 'barchart', 
                        :options => {  :row_count => true  },
                        :ss => query.map { |r| [ r.name, r.count.to_i ] }}                   
      end
      
  
      # Costs By Practice
      ticked=params[:cost_by_practice]
      session[:report][:cost_by_practice] = ticked
      if ( ticked )
        query = Query.find_by_sql([
          "select o.name, count(c.id) count, sum(c.amount) total \n"+
          "from claims c\n"+
          "  left join organisations o on o.id = c.cost_organisation_id\n"+
          "where c.invoice_date >= ?  and c.invoice_date <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and  c.claim_status_id <= 6\n"+
          "   and #{filter}\n"+
          "group by o.name, o.est_no_patients\n"+
          "order by 2 desc\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
          # Convert Query into array hashes. 
          
        @results << { :title => 'Total Cost by Practice', :partial_name => 'barchart', 
                      :note => '$\'s',
                        :options => { },
                        :ss => query.map { |r| [ r.name, r.total.to_f.round ] }}                   
      end
    end # org_loop 
    # Save the Data against the session, So can down-load to excel
    session[:results] = @results
  end
  
  def csv
    require 'faster_csv'
    
    content_type = ( request.user_agent =~ /windows/i ?  'application/vnd.ms-excel' : 'text/csv' )
    content = FasterCSV.generate do |csv|
      results=session[:results]
      if ( results )
        for r in results do
          csv << [r[:title],r[:note]]
          for row in r[:ss] do 
             csv << row
          end
          csv << ''
          csv << ''
        end
      else 
         csv << '!!!No results in session'
      end
    end
    send_data(content,:type => content_type, :filename => 'utilisation.csv' )
  end    
  
  
end
