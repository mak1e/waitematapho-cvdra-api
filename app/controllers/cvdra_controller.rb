class CvdraController < ApplicationController
  layout 'cvdra'
    
  caches_page  :nhi  
  skip_before_filter :verify_authenticity_token, :only => [ :nhi ]
  skip_before_filter :check_role_system_admin, :only => [ :nhi, :cvdra ]
  skip_before_filter :check_role_claims_admin, :only => [ :nhi, :cvdra ]
  skip_before_filter :check_role_claims_processing, :only => [ :nhi, :cvdra ]
  skip_before_filter :check_role_payment_processing, :only => [ :nhi, :cvdra ]
  
  require 'json'   
  def nhi

    @nhi = nil
    @nhin = nil
    @nhiu = nil
    content_type = 'application/json'
    today = Time.now.in_time_zone('Auckland').to_date 
    five_years = today - 5.years
    three_years = today - ( 3.years + 3.months )
    
    # remove this once implemented live on the server for testing
=begin
    params[:access_token] = "lSEOasafriYQFtpizybdjDJbrMZyoAcc9dNh0u6PPsadGpqy"
    params[:nhi] = "TFP3459"
    params[:commit] = true
=end  
      
    if params[:access_token] == "lSEOasafriYQFtpizybdjDJbrMZyoAcc9dNh0u6PPsadGpqy" && (params[:commit])      
      
      unless (params[:nhi].blank?) && request.method == "POST"
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
                and c.programme_id = 2
                and c.fee_schedule_id in (20, 22, 24, 26, 3710, 3709)
                --and f.code like ('CVD%')
                and o.cbf_ident not in  
                            ('NHAPO', 'NHHAU' , 'NHSHA', 'NHWHA'  
                            , 'NMDNL' , 'NMKAI', 'NMKEL', 'NMLIN' 
                            , 'NMMCP', 'NMNAP', 'NMRAN', 'NMRAT', 'NMWEV') -- 'NMWAT' is now part of WPHO effective 01Oct2013 
              
                and o.cbf_ident is not null " + 
            " and ( c.date_service >= '" + five_years.to_s + "' " +     
            " and c.date_service <= '" + today.to_s + "' )" +  
            " and p.nhi_no in (" + nhi + ") " + 
            " order by  c.date_service desc  " 
            
            @nhi=Query.connection.raw_select( query_nhi ) # true CVD% --> (BXY8616, AQL2552, NDX7124)  | null CVDRA --> (TFP3459)            

####################                        
# BEGIN code=N
            
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
                  , c.date_service serviceDate  
                  , o.name practiceName 
                  , o.hlink ediAccount  
                          
              from claims c 
                  left join patients p on p.id = c.patient_id 
                  left join organisations o on o.id = p.organisation_id  
              
              where   
                  o.cbf_ident not in  
                              ('NHAPO', 'NHHAU' , 'NHSHA', 'NHWHA'  
                              , 'NMDNL' , 'NMKAI', 'NMKEL', 'NMLIN' 
                              , 'NMMCP', 'NMNAP', 'NMRAN', 'NMRAT', 'NMWEV') 
                
                  and o.cbf_ident is not null 
                  and ( 
                    ( c.programme_id = 2
                    and c.fee_schedule_id in (20, 22, 24, 26, 3710, 3709) " +
                      
              "     and c.date_service <= '" + five_years.to_s + "' ) or ( c.date_service >= '" + three_years.to_s + "') )" +     
#              "     and c.date_service <= '" + five_years.to_s + "' ) or ( c.date_service >= '2013-07-20') )" +     
              
              "   and p.nhi_no in (" + nhi + ") " + 
              "   order by c.date_service desc  " 

#               " and c.date_service >= '" + three_years.to_s + "' " +   
              @nhin=Query.connection.raw_select( query_nhi_n )   
            
          end
          end
# END code=N          
####################                        


          ####################                        
          # BEGIN code=U
                      
          if @nhin
            n = 0

            @nhin.each do |r|
              r.each do |c|
                n += 1
              end
            end
  
            if n <= 5
  
              query_nhi_u = 
                "select top 1 p.nhi_no NHI 
                  from claims c 
                    left join patients p on p.id = c.patient_id 
                    left join organisations o on o.id = c.cost_organisation_id  
                  where p.nhi_no in (" + nhi + ") 
                    and p.organisation_id is not null
          
          and ( c.date_service >= '" + three_years.to_s + "') 
          
                    and o.cbf_ident not in  
                                ('NHAPO', 'NHHAU' , 'NHSHA', 'NHWHA'  
                                , 'NMDNL' , 'NMKAI', 'NMKEL', 'NMLIN' 
                                , 'NMMCP', 'NMNAP', 'NMRAN', 'NMRAT', 'NMWEV') "
                      
              @nhiu=Query.connection.raw_select( query_nhi_u )
              
            end
          end
                              
          # END code=U          
          ####################                        

                    
                  
        end # begin   
      end # unless
    end # if params
  
  end # def nhi
        
end # class CvdraController
#form_tag( {:action => 'nhi'}, { :autocomplete => :off } )  do 
