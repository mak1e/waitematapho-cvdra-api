class TestcvdraController < ApplicationController
  layout 'cvdra'
    
  caches_page  :nhi, :testcvdra  
  skip_before_filter :verify_authenticity_token, :only => [ :nhi, :testcvdra ]

=begin
  <!--textarea cols="40" rows="2" id="nhi" name="nhi" ><%= params[:nhi] %></textarea-->
  <input type="text" id="nhi" name="nhi" value="<%= params[:nhi] %>">
=end
  require 'json'   
  def nhi

    @nhi = nil
    @nhin = nil
    content_type = 'application/json'
    today = Time.now.in_time_zone('Auckland').to_date 
    five_years = today - 5.years
    three_years = today - 3.years

    
    # <input type="hidden" id="access_token" name="access_token" value="lSEOasafriYQFtpizybdjDJbrMZyoAcc9dNh0u6PPsadGpqy">
    # remove this once implemented live on the server for testing
#=begin
    params[:access_token] = "lSEOasafriYQFtpizybdjDJbrMZyoAcc9dNh0u6PPsadGpqy"
    params[:nhi] = "TFP3459"
    params[:commit] = true
#=end  
      
    if params[:access_token] == "lSEOasafriYQFtpizybdjDJbrMZyoAcc9dNh0u6PPsadGpqy" && (params[:commit])      
      
      unless (params[:nhi].blank?) 
      nhi="'"+params[:nhi]+"'"
        begin
          
          query_nhi = 
            "select top 1  
                p.nhi_no NHI  
                , d.cvdr_cvd_risk   
                , c.date_service serviceDate  
                , o.name practiceName 
                , o.hlink ediAccount  
                        
            from claims c 
                left join claims_data d on d.id = c.id  
                left join patients p on p.id = c.patient_id 
                left join organisations o on o.id = c.cost_organisation_id  
                left join fee_schedules f on f.id = c.fee_schedule_id
            
            where   
                d.cvdr_cvd_risk is not null
                --and f.code like ('CVD%')
                and o.cbf_ident not in  
                            ('NHAPO', 'NHHAU' , 'NHSHA', 'NHWHA'  
                            , 'NMDNL' , 'NMKAI', 'NMKEL', 'NMLIN' 
                            , 'NMMCP', 'NMNAP', 'NMRAN', 'NMRAT', 'NMWAT', 'NMWEV') 
              
                and o.cbf_ident is not null " + 
            " and c.date_service >= '" + five_years.to_s + "' " +     
            " and c.date_service <= '" + today.to_s + "' " +  
            " and p.nhi_no in (" + nhi + ") " + 
            " order by  c.date_service desc  " 
            
            @nhi=Query.connection.raw_select( query_nhi )   
            # true CVD% --> (BXY8616, AQL2552, TFP3459, NDX7124)
            # null CVDRA --> (TFP3459)            
                        
# BEGIN code=Y
            
          if @nhi
            n = 0

          @nhi.each do |r|
            r.each do |c|
            n += 1
            end
          end

          if n < 10
            query_nhi_n = 
              "select top 1  
                  p.nhi_no NHI  
                  , d.cvdr_cvd_risk   
                  , c.date_service serviceDate  
                  , o.name practiceName 
                  , o.hlink ediAccount  
                          
              from claims c 
                  left join claims_data d on d.id = c.id  
                  left join patients p on p.id = c.patient_id 
                  left join organisations o on o.id = c.cost_organisation_id  
                  left join fee_schedules f on f.id = c.fee_schedule_id
              
              where   
                  d.cvdr_cvd_risk is null
                  and f.code not like ('CVD%')
                  and o.cbf_ident not in  
                              ('NHAPO', 'NHHAU' , 'NHSHA', 'NHWHA'  
                              , 'NMDNL' , 'NMKAI', 'NMKEL', 'NMLIN' 
                              , 'NMMCP', 'NMNAP', 'NMRAN', 'NMRAT', 'NMWAT', 'NMWEV') 
                
                  and o.cbf_ident is not null " + 
              " and c.date_service >= '" + three_years.to_s + "' " +     
              " and c.date_service <= '" + today.to_s + "' " +  
              " and p.nhi_no in (" + nhi + ") " + 
              " order by  c.date_service desc  " 
              
              @nhin=Query.connection.raw_select( query_nhi_n )   
            
            
          end
          end
# END code=N          
        
        end # begin   
      end # unless
    end # if params
  
  end # def nhi
        
end

#form_tag( {:action => 'nhi'}, { :autocomplete => :off } )  do 
#submit_tag 'Find NHI ...' 
