class CbfController < ApplicationController
  layout 'default'
  before_filter :check_role_payment_processing, :only => [ :show, :advice, :csv ]
  
  def list
    @payments=PaymentRun.find(:all,:order=>'id desc')
  end
  
  def show
    yyyy_mm=params[:id].split('-')
    @cbf_month=Date.new(yyyy_mm[0].to_i,yyyy_mm[1].to_i,1)
    @cbf_summary=Linktech.cbf_summary(@cbf_month)
    # render :text=> "#{@cbf_month}", :status => 200
    # render :action => "advice", :layout => false
  end
  
  def csv
    yyyy_mm=params[:id].split('-')
    cbf_month=Date.new(yyyy_mm[0].to_i,yyyy_mm[1].to_i,1)

    csv=Linktech.cbf_summary_csv(cbf_month)
    
    content_type = ( request.user_agent =~ /windows/i ?  'application/vnd.ms-excel' : 'text/csv' )
    send_data(csv,:type => content_type, :filename => "payment-CBF-#{params[:id]}.csv" )
  end
  
  # Generate SAGE payment file.
  def sage
    yyyy_mm=params[:id].split('-')
    cbf_month=Date.new(yyyy_mm[0].to_i,yyyy_mm[1].to_i,1)
    
    csv=Linktech.cbf_sage_payment_file(cbf_month)
    
    # MS: 2011-10-17 Changed extn from .csv to .txt as this is the default in sage
    send_data(csv,:type => 'text/plain', :filename => "sage-CBF-#{cbf_month.strftime('%Y-%m')}.txt" )
  end
  
  
  def advice
    yyyy_mm=params[:id].split('-')
    @cbf_month=Date.new(yyyy_mm[0].to_i,yyyy_mm[1].to_i,1)
    @cbf_ident=params[:cbf_ident]
    @cbf_organisation=Organisation.find_by_cbf_ident(@cbf_ident)
    
    # If cant find it make up an organisation.
    unless @cbf_organisation
      @cbf_organisation=Organisation.new
      @cbf_organisation.name = 'CBF ID#' + @cbf_ident
      @cbf_organisation.cbf_ident = @cbf_ident
    end
      
    
    @cbf_summary=Linktech.cbf_summary(@cbf_month,@cbf_ident)
    @cbf_summary_by_agegroup = Linktech.cbf_summary_by_agegroup(@cbf_month,@cbf_ident) 

    @cbf_breakdown_by_registration_no=Linktech.cbf_breakdown_by_registration_no(@cbf_month,@cbf_ident)
    @cbf_extras_by_registration_no=Linktech.cbf_extras_by_registration_no(@cbf_month,@cbf_ident)

    @ffs_deductions_by_age_group_dow=Linktech.ffs_deductions_by_age_group_dow(@cbf_month,@cbf_ident)
    @ffs_deductions_by_gms_claim=Linktech.ffs_deductions_by_gms_claim(@cbf_month,@cbf_ident)

    @ffs_deduction_details=Linktech.ffs_deduction_details(@cbf_month,@cbf_ident)
    
    if ( @cbf_summary.length != 1  )
      render :text=> "ADVICE not found, Month #{@cbf_month}, Ident #{@cbf_ident}", :status => 200
    else
      @cbf_summary = @cbf_summary[0]
      render :action => "advice", :layout => false
    end
  end  
  
end
