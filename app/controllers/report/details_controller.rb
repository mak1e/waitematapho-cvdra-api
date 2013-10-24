class Report::DetailsController < Report::BaseController

  # Extend Criteria Class
  
  
  def criteria
    # Need an object, So can set the defaults on the date 
    @criteria = Criteria.new
    
    @criteria.end_date = Date.today.last_month.end_of_month;
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
    
    session[:details] ||= {}
    
    organisation_filter = '1=1'
    organisation_filter = "c.cost_organisation_id = #{@criteria.organisation_id}" unless @criteria.organisation_id.blank?
    
    filter = '1=1'
    if ( @criteria.care_plus_only )
      filter = 'p.is_care_plus = 1 and p.organisation_id = c.cost_organisation_id'
    end
    
    
    ticked=params[:patients_seen_by_practice]
    session[:details][:patients_seen_by_practice] = ticked
    if ticked
      query = Query.find_by_sql([
          "select c.cost_organisation_id organisation_id, c.patient_id, p.nhi_no, p.family_name, p.given_names,p.date_of_birth,\n"+
          "       min(c.date_service) ist_visit, max(c.date_service) last_visit, max(c.cplus_enrolled) cplus_enrolled, max(c.huhc_holder) huhc_holder, max(f.is_a_exit_service) is_closed, sum(c.amount) amount\n"+
          "from claims c \n"+
          "  left join patients p on p.id = c.patient_id\n"+
          " left join fee_schedules f on f.id = c.fee_schedule_id\n"+
          "where c.programme_id = ? and c.date_service >= ?  and c.date_service <= ?\n"+
          "  and c.claim_status_id <= 6\n"+
          "  and #{organisation_filter}\n"+
          "  and #{filter}\n"+
          "group by c.cost_organisation_id, c.patient_id, p.nhi_no, p.family_name, p.given_names,p.date_of_birth\n"+
          "order by c.cost_organisation_id, min(c.date_service)",
            @criteria.programme_id,@criteria.start_date,@criteria.end_date] )
            
      for g in query.in_groups_by(&:organisation_id) do
         @results << { :title => 'Patients Seen', 
                       :note => nil,
                       :organisation_id => g[0].organisation_id,
                       :query => g }
      end
    end
    
    ticked=params[:new_patients_by_practice]
    session[:details][:new_patients_by_practice] = ticked
    if ticked
      query = Query.find_by_sql([
          "select c.cost_organisation_id organisation_id, c.patient_id, p.nhi_no, p.family_name, p.given_names,p.date_of_birth,\n"+
          "       min(c.invoice_date) ist_visit, max(c.invoice_date) last_visit, max(c.cplus_enrolled) cplus_enrolled, max(c.huhc_holder) huhc_holder, max(f.is_a_exit_service) is_closed, sum(c.amount) amount\n"+
          "from claims c \n"+
          "  left join claims oldc on oldc.patient_id = c.patient_id and oldc.programme_id = c.programme_id and oldc.date_service < c.date_service  and oldc.claim_status_id <= 6\n"+
          "  left join patients p on p.id = c.patient_id\n"+
          " left join fee_schedules f on f.id = c.fee_schedule_id\n"+
          "where c.programme_id = ? and c.date_service >= ?  and c.date_service <= ?\n"+
          "  and c.claim_status_id <= 6\n"+
          "  and oldc.id is null\n"+
          "  and #{organisation_filter}\n"+
          "  and #{filter}\n"+
          "group by c.cost_organisation_id, c.patient_id, p.nhi_no, p.family_name, p.given_names,p.date_of_birth\n"+
          "order by c.cost_organisation_id, min(c.invoice_date)",
            @criteria.programme_id,@criteria.start_date,@criteria.end_date] )
            
      for g in query.in_groups_by(&:organisation_id) do
         @results << { :title => 'New Patients', 
                       :note => nil,
                       :organisation_id => g[0].organisation_id,
                       :query => g }
      end
    end

    ticked=params[:patient_visit_dates]
    session[:details][:patient_visit_dates] = ticked
    if ticked
      query = Query.find_by_sql([
          "select c.cost_organisation_id organisation_id, c.patient_id, p.nhi_no, p.family_name, p.given_names,p.date_of_birth, c.date_service\n"+
          "from claims c \n"+
          "  left join patients p on p.id = c.patient_id\n"+
          " left join fee_schedules f on f.id = c.fee_schedule_id\n"+
          "where c.programme_id = ? and c.date_service >= ?  and c.date_service <= ?\n"+
          "  and c.claim_status_id <= 6\n"+
          "  and #{organisation_filter}\n"+
          "  and #{filter}\n"+
          "order by c.cost_organisation_id, p.family_name, p.given_names, c.patient_id, c.date_service",
            @criteria.programme_id,@criteria.start_date,@criteria.end_date] )
            
      for g in query.in_groups_by(&:organisation_id) do
         @results << { :title => 'Patient Visits', 
                       :note => nil,
                       :partial_name => 'listvisits',
                       :organisation_id => g[0].organisation_id,
                       :query => g }
      end
    end    

    
    if ( @results.length == 0  )
      flash[:alert] = 'No records found'
      redirect_to :action => 'criteria'
    end
  end

  
  
end
