class PaymentController < ApplicationController
  layout 'default'
  before_filter :check_role_payment_processing, :only => [ :new, :edit, :review, :commit, :undo, :show, :show ]
  
  RECORD_CLASS = PaymentRun
  
  def list
    @payments=PaymentRun.find(:all,:order=>'id desc')
  end
  
  def new
    PaymentRun.delete_all('id = 1')
    # User wishes to do a new payment, Run. 
    # Prompt for the cut off date. 
    # Need an object, So can set the defaults on the date 
    @payment_run = PaymentRun.new
    # Default Date to the Last dat of last month
    @payment_run.cut_off_date = Time.now.beginning_of_month.to_date
    nm = @payment_run.cut_off_date
    nm = nm.next_month if ( nm.day >= 20 )
    @payment_run.payment_date = Date.new(nm.year,nm.month,20);
  end
    
  def review
    PaymentRun.delete_all('id = 1')
    # New -> review
    # We have criteria for the run, 
    # Place a tentative payment run, Against reserved run_id "1"
    # And display details
    
    @payment_run = PaymentRun.new(params[:payment_run])
    @payment_run.id = 1 # Fake the id until saved !!
    @payment_run.programme_id = 99 # Not by programme yet 
    @payment_run.user_id = session[:user_id]
    @payment_run.save
    
    # Reset any failed/aborted payments runs
    Claim.update_all('payment_run_id = 0','payment_run_id = 1' )
    # Find the trans to pay
    Claim.update_all('payment_run_id = 1',['payment_run_id = 0 and (claim_status_id = ? or claim_status_id = ?) and invoice_date < ?', ClaimStatus::ACCEPTED,ClaimStatus::BORDERLINE, @payment_run.cut_off_date ]);
    # Show payments
  end
  
  def commit
    PaymentRun.delete_all('id = 1')
    # New -> review -> commit
    # User said ok, to the payment run, 
    # Create a new payment-run and display the final view
    @payment_run = PaymentRun.new(params[:payment_run])
    # run.user_id = session[:user_id]
    @payment_run.programme_id = 99 # Not by programme yet 
    @payment_run.user_id = session[:user_id]
    @payment_run.save!
    
    # Find the trans to pay
    Claim.update_all("payment_run_id = #{@payment_run.id}",'payment_run_id = 1');
    # Show payments
    redirect_to  :action => 'show', :id => @payment_run.id
  end    
  
  def advice
    @payment_run = PaymentRun.find(params[:id])
    render :action => "advice", :layout => false
  end
  
  def advice2
    @payment_run = PaymentRun.find(params[:id])
    render :action => "advice2", :layout => false
  end
  
  # Provide the Southlink Health slh, payment text file. 
  # The file format is very simple. txt file with the following
  # Doctor Name|DOCTORCODE|PROGRAMME-NAME|GL-CODE|AMOUNT
  # e.g. Horner A|HORNERA|Free Targeted Health Check|6409-74|80.00
  def slh
    @payment_run = PaymentRun.find(params[:id])
    
    paydates = ''
    paydates = @payment_run.payment_date.to_s(:local) unless @payment_run.payment_date.blank?
    #paydates.sub!(' ','-')
    
    send_data(@payment_run.slh_payment_file,:type => 'text/plain', :filename => "payments-RUN#{@payment_run.id}-#{paydates}.txt" )
  end
  
  # Provide the Well Dunedin csv file. 
  # Doctor Name,Cut-Off/Invoice-Date,Payment/Due-Date,Amount,GL-Coide
  # Horner A,01/07/2009,20/07/2009,80.00,6409-74
  
  def welldcsv
    @payment_run = PaymentRun.find(params[:id])
    
    paydates = ''
    paydates = @payment_run.payment_date.to_s(:local) unless @payment_run.payment_date.blank?
    
    send_data(@payment_run.welld_payment_file,:type => 'text/plain', :filename => "payments-RUN#{@payment_run.id}-#{paydates}.csv" )
  end

  # Generate SAGE payment file.
  def sage
    @payment_run = PaymentRun.find(params[:id])
    # MS: 2011-10-17 Changed extn from .csv to .txt as this is the default in sage
    send_data(@payment_run.sage_payment_file,:type => 'text/plain', :filename => "sage-RUN#{@payment_run.id}.txt" )
  end
  
  
  
  def undo
    run=PaymentRun.find(:first, :order => "id DESC");
    flash[:alert] = "Payment run #{run.id} cancelled"
    Claim.update_all("payment_run_id = 0","payment_run_id = #{run.id}");
    run.note = 'Cancelled'
    run.save
    redirect_to :action => "list"
  end      
end
