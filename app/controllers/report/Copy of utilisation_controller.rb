class Report::UtilisationController < Report::BaseController
 
   
  def criteria
    # Need an object, So can set the defaults on the date 
    @criteria = Criteria.new
    @criteria.start_date = Date.today.at_beginning_of_month.last_month
    @criteria.end_date = @criteria.start_date.end_of_month
    @criteria.start_date = @criteria.start_date.months_since( -2 )    # Default to a Qtr
    
    @criteria.restore_from_session(session)
  end 
  
  
  # Run cvdr query on the database, with a filter 
  def run_cvdr_query(heading,filter)
      filter = '1=1' if filter.blank?
      query = Query.find_by_sql([
        "select dbo.ethnicity_cvdr(p.ethnicity_id) ethnicity, '#{heading}' heading, count(c.id) count\n"+
        "from claims c\n"+
        "  left join claims_data d on d.id = c.id\n"+
        "  left join patients p on p.id = c.patient_id\n"+
        "where c.date_service >= ?  and c.date_service <= ? \n"+
        " and c.programme_id = ?\n"+
        " and c.claim_status_id <= 6\n"+
        " and d.cvdr_cvd_risk > 0\n"+
        " and #{filter}\n"+
        # Exclude if a more recient "accepted" claim exists for the patient !!
        "  and not exists ( select 1 \n"+
        "    from claims xc \n"+
        "       left join claims_data xd on xd.id = xc.id\n"+
        "     where xc.patient_id = c.patient_id\n"+
        "       and xc.date_service > c.date_service and xc.date_service <= ?\n"+
        "       and xc.claim_status_id <= 6\n"+
        "       and xc.programme_id = ?\n"+
        "       and xd.cvdr_cvd_risk > 0 ) \n"+
        "group by dbo.ethnicity_cvdr(p.ethnicity_id)\n"+
        "order by 1\n",
         @criteria.start_date, @criteria.end_date, @criteria.programme_id,
         @criteria.end_date,@criteria.programme_id ])
      query
  end  
  
  # Run ethnicity query on the database, with a filter 
  def run_eth_query(heading,filter)
      filter = '1=1' if filter.blank?
      query = Query.find_by_sql([
          "select IsNull(el1.id,9),el1.description ethnicity, '#{heading}' heading, count(c.id) count\n"+
          "from claims c\n"+
          "  left join claims_data d on d.id = c.id\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          "    left join ethnicities eth on eth.id = p.ethnicity_id \n"+
          "      left join level1_ethnicities el1 on el1.id = eth.level1_ethnicity_id\n"+
          "where c.date_service >= ?  and c.date_service <= ? \n"+
          "   and c.programme_id = ?\n"+
          "   and c.claim_status_id <= 6\n"+
          "   and #{filter}\n"+
          "group by IsNull(el1.id,9),el1.description\n"+
          "order by 1\n",
           @criteria.start_date, @criteria.end_date, @criteria.programme_id])
      query
  end
  
  def result
    @criteria = Criteria.new(params[:criteria]);
    
    @criteria.start_date = @criteria.start_date.at_beginning_of_month
    @criteria.end_date = @criteria.end_date.end_of_month
    
    @criteria.save_to_session(session)

    
    # Build up and array of hashes, containing the title, partial to render, and the spread sheet
    # First spread sheet contains the criteria for the report, But dont render
    @results = [{ :title => 'Report Criteria', :partial_name => nil, 
                    :ss => [ ['Start Date', @criteria.start_date.to_s(:local) ],
                             ['End Date', @criteria.end_date.to_s(:local) ],                    
                             ['Programme',@criteria.programme.description ],                    
                             ['Service',@criteria.fee_schedule_id.blank? ? 'All' : @criteria.fee_schedule.description ],                    
                             ['Organisation',@criteria.organisation_id.blank? ? 'All' : @criteria.organisation.name  ],                    
                             ['Generated at', Time.now.to_s(:local) ]] }]

    filter = '1=1'
    filter += "  and c.cost_organisation_id = #{@criteria.organisation_id}\n" unless @criteria.organisation_id.blank?
    filter += "  and c.fee_schedule_id = #{@criteria.fee_schedule_id}\n" unless @criteria.fee_schedule_id.blank?

    # Utilisation By Service
    ticked=params[:monthly_trends]
    session[:report][:monthly_trends] = ticked
    if ( ticked )
      query = Query.find_by_sql([
        "select month(c.date_service) mm, year(c.date_service) yyy, count(c.id) count\n"+
        "from claims c\n"+
        "where c.date_service >= ?  and c.date_service <= ? \n"+
        "   and c.programme_id = ?\n"+
        "   and c.claim_status_id <= 6\n"+
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
        
      @results << { :title => 'Utilisation by Service', :partial_name => 'barchart', 
                      :options => { },
                      :ss => query.map { |r| [ r.description, r.count.to_i ] } }    
    end                    

    # Utilisation By Ethnicity
    ticked=params[:utilisation_by_ethnicity]
    session[:report][:utilisation_by_ethnicity] = ticked
    if ( ticked )
      query = run_eth_query('na',filter)
      # Convert Query into array hashes. 
      @results << { :title => 'Utilisation by Ethnicity', :partial_name => 'barchart', 
                      :options => { },
                      :ss => query.map { |r| [ r.ethnicity, r.count.to_i ] } }
    end

    # Utilisation By Age
    ticked=params[:utilisation_by_age]
    session[:report][:utilisation_by_age] = ticked
    if ( ticked )
      agerange_field="dbo.agerange_gms(p.date_of_birth, cast('#{@criteria.end_date.to_s(:db)}' as datetime))"
      query = Query.find_by_sql([
        "select #{agerange_field} agerange, count(c.id) count\n"+
        "from claims c\n"+
        "  left join patients p on p.id = c.patient_id\n"+
        "where c.date_service >= ?  and c.date_service <= ? \n"+
        "   and c.programme_id = ?\n"+
        "   and c.claim_status_id <= 6\n"+
        "   and #{filter}\n"+
        "group by #{agerange_field}\n"+
        "order by 1\n",
        @criteria.start_date, @criteria.end_date, @criteria.programme_id])
  
      @results << { :title => 'Utilisation by Age', :partial_name => 'barchart', 
                      :options => { },
                      :ss => query.map { |r| [ r.agerange, r.count.to_i ] } }
    end

    # Utilisation By Gender
    ticked=params[:utilisation_by_gender]
    session[:report][:utilisation_by_gender] = ticked
    if ( ticked )
      query = Query.find_by_sql([
        "select gen.description, count(c.id) count\n"+
        "from claims c\n"+
        "  left join patients p on p.id = c.patient_id\n"+
        "    left join genders gen on gen.id = p.gender_id\n"+
        "where c.date_service >= ?  and c.date_service <= ? \n"+
        "   and c.programme_id = ?\n"+
        "   and c.claim_status_id <= 6\n"+
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
        "from claims c\n"+
        "  left join patients p on p.id = c.patient_id\n"+
        "where c.date_service >= ?  and c.date_service <= ? \n"+
        "   and c.programme_id = ?\n"+
        "   and c.claim_status_id <= 6\n"+
        "   and #{filter}\n"+
        "group by p.quintile\n"+
        "order by 1 desc\n",
         @criteria.start_date, @criteria.end_date, @criteria.programme_id])
        # Convert Query into array hashes. 
        
      @results << { :title => 'Utilisation by Quintile', :partial_name => 'barchart', 
                      :options => { },
                       :ss => query.map { |r| [ r.quintile, r.count.to_i ] } }
    end       
    

    # Diabetes Dataset
    ticked=params[:diabetes_dataset]
    session[:report][:diabetes_dataset] = ticked
    if ( ticked )
        query = run_eth_query('No of  Assessments',filter)
        ss=merge_to_array_nXn(query,'heading','ethnicity','count');
                        
        # Ethnicity by Type 1 Diabetes 
        query = run_eth_query('Type 1 Diabetes',"#{filter} and d.diab_type_of_diabetes = 'Type 1'")
        ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
  
        # Ethnicity by Type 2 Diabetes 
        query = run_eth_query('Type 2 Diabetes',"#{filter} and d.diab_type_of_diabetes = 'Type 2'")
        ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
        
        # Ethnicity by Retinal Screen in the last 2 years. #  
        query = run_eth_query('Retinal Screen last 2yrs',"#{filter} and d.diab_type_of_diabetes = 'Type 2' and datediff(yyyy,d.retind_date_last_retinal_screening,c.date_service) between 0 and 2")
        ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
  
        # Ethnicity by Hba1c Recorded
        query = run_eth_query('HBA1c Recorded',"#{filter} and d.hba1c_hba1c > 1.00")
        ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
  
        # Ethnicity by Hba1c > 7% or 53 mmol/mol # Max % is 15%
        query = run_eth_query('HBA1c > 7.0',"#{filter} and d.hba1c_hba1c > 7.00")  
        # query = run_eth_query('HBA1c > 7% / 53 mmol/mol',"#{filter} and (( d.hba1c_hba1c > 7.00 and d.hba1c_hba1c < 15.00 ) OR ( d.hba1c_hba1c > 53.00 ))")  
        ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
  
        # Ethnicity by Hba1c > 8% or 64 mmol/mol
        query = run_eth_query('HBA1c > 8.0',"#{filter} and d.hba1c_hba1c > 8.00") # 
        # query = run_eth_query('HBA1c > 8% / 64 mmol/mol',"#{filter} and (( d.hba1c_hba1c > 7.00 and d.hba1c_hba1c < 15.00 ) OR ( d.hba1c_hba1c > 53.00 ))")  
        ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
  
        # Ethnicity by Smoking History
        query = run_eth_query('Current Smoker',"#{filter} and d.smok_smoking_history like 'Yes%'")
        ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
  
  
        # Ethnicity by Ace Inhibitor
        query = run_eth_query('ACE Inhibitor',"#{filter} and d.acei_ace_inhibitor like 'Yes%'")
        ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
  
        # Ethnicity by total cholesterol Recorded
        query = run_eth_query('Total Chol Recorded',"#{filter} and d.tc_total_cholesterol > 0.00")
        ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
  
  
        # Ethnicity by total cholesterol > 9.0
        query = run_eth_query('Total Chol > 9.0',"#{filter} and d.tc_total_cholesterol > 9.00")
        ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
  
        # Ethnicity by Statin
        query = run_eth_query('Statin',"#{filter} and d.statin_statin like 'Yes%'")
        ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
  
  
        @results << { :title => 'Diabetes Dataset', :partial_name => 'spreadsheet', 
                        :options => { :total => false },
                        :ss =>  ss }
      
    end

    # CVDR Data
    ticked=params[:cvdr_dataset]
    session[:report][:cvdr_dataset] = ticked
    if ( ticked )
       query=run_cvdr_query('Total patients screened',filter);
  
  
       # Build up data set
       ss=merge_to_array_nXn(query,'heading','ethnicity','count');
       
       noCVD = "(( d.angi_angina_ami is null  or d.angi_angina_ami like 'No%' ) and\n" + 
                 "( d.tia_stroke_tia is null  or d.tia_stroke_tia like 'No%' ) and\n" + 
                 "( d.pvd_peripheral_vessel_disease is null  or d.pvd_peripheral_vessel_disease like 'No%' ) and\n" + 
                 "( d.atfi_atrial_fibrillation is null  or d.atfi_atrial_fibrillation like 'No%' ) and\n" + 
                 "( d.mets_diagnosed_metabolic_syndrome is null  or d.mets_diagnosed_metabolic_syndrome like 'No%' ) and\n" +  
                 "( d.gld_genetic_lipid_disorder is null  or d.gld_genetic_lipid_disorder like 'No%' ))\n"
        
        noDIAB = "( d.diab_type_of_diabetes is null  or d.diab_type_of_diabetes like 'No%' )\n"
        
        lowRISK = "( d.cvdr_cvd_risk < 10.0 )"
        mediumRISK = "( d.cvdr_cvd_risk >= 10.0 and d.cvdr_cvd_risk <= 15.0 )"
        highRISK = "( d.cvdr_cvd_risk > 15.0 )"
        
  
       query=run_cvdr_query('... with Existing CVD',"#{filter} and (not #{noCVD})");
       ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
       query=run_cvdr_query('... with Diabetes',"#{filter} and (not #{noDIAB})");
       ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
       query=run_cvdr_query('... with Diabetes+CVD ',"#{filter} and (not #{noDIAB} and not #{noCVD})");
       ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
       query=run_cvdr_query('... without Diabetes/CVD ',"#{filter} and (#{noDIAB} and  #{noCVD})");
       ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
       
       @results << { :title => 'CVDR Assessment Breakdown', :partial_name => 'spreadsheet', 
                        :options => { :total => false },
                        :ss =>  ss }
                        
       # Risk Levels
       query=run_cvdr_query('Total  <10%',"( #{filter} and #{lowRISK} )");
       ss=merge_to_array_nXn(query,'heading','ethnicity','count');
       bar=merge_to_array_nX2(query,'heading','count')
       
       query=run_cvdr_query('Total 10..15%',"( #{filter} and #{mediumRISK} )");
       ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
       bar=merge_to_array_nX2(query,'heading','count',bar)
       
       query=run_cvdr_query('Total >15%',"( #{filter} and #{highRISK} )");
       ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
       bar=merge_to_array_nX2(query,'heading','count',bar)
  
       query=run_cvdr_query('Diabetes <10%',"( #{filter} and #{lowRISK} and not #{noDIAB} )");
       ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
       query=run_cvdr_query('Diabetes 10..15%',"( #{filter} and #{mediumRISK} and not #{noDIAB} )");
       ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
       query=run_cvdr_query('Diabetes >15%',"( #{filter} and #{highRISK} and not #{noDIAB} )");
       ss=merge_to_array_nXn(query,'heading','ethnicity','count',ss);
  
       @results << { :title => 'Assessments by Risk Level', :partial_name => 'barchart', 
                       :options => { },
                       :ss =>  bar }
       
       @results << { :title => 'Risk Level  Breakdown', :partial_name => 'spreadsheet', 
                        :options => { :total => false },
                        :ss =>  ss }
    end

    # Utilisation By Practice
    ticked=params[:utilisation_by_practice]
    session[:report][:utilisation_by_practice] = ticked
    if ( ticked )
      query = Query.find_by_sql([
        "select o.id organisation_id, o.name, count(c.id) count, IsNull(o.est_no_patients,0) popn, (count(c.id)*100.00) / o.est_no_patients perage\n"+
        "from claims c\n"+
        "  left join organisations o on o.id = c.cost_organisation_id\n"+
        "where c.date_service >= ?  and c.date_service <= ? \n"+
        "   and c.programme_id = ?\n"+
        "   and c.claim_status_id <= 6\n"+
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
                      :options => { },
                      :ss => ss }                   
    end
    
    # Utilisation By Service Provider
    ticked=params[:utilisation_by_service_provider]
    session[:report][:utilisation_by_service_provider] = ticked
    if ( ticked )
      query = Query.find_by_sql([
        "select p.name, count(c.id) count \n"+
        "from claims c\n"+
        "  left join providers p on p.id = c.service_provider_id \n"+
        "where c.date_service >= ?  and c.date_service <= ? \n"+
        "   and c.programme_id = ?\n"+
        "   and c.claim_status_id <= 6\n"+
          "   and #{filter}\n"+
        "group by p.name\n"+
        "order by 2 desc\n",
         @criteria.start_date, @criteria.end_date, @criteria.programme_id])
        # Convert Query into array hashes. 
        
      @results << { :title => 'Utilisation by Service Provider', :partial_name => 'barchart', 
                      :options => { },
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
        "where c.date_service >= ?  and c.date_service <= ? \n"+
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
