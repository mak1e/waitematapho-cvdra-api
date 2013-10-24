class ClaimController < ApplicationController
  
    protect_from_forgery :except => [ :lodge, :ping ]
    
    skip_before_filter :logged_in, :only => [ :lodge, :ping ]
    before_filter :check_role_claims_processing, :only => [ :edit, :new, :post ]
  
    
    # skip_before_filter :verify_authenticity_token
    
    layout 'default'
    
    RECORD_CLASS = Claim
    
    # user super class to show, but remember patient/organisation
    def show
      super
      session[:patient_id] = @claim.patient_id
      session[:organisation_id] = @claim.organisation_id
      
      access_log( @claim.patient_id, @claim.id )
    end    
    
    def edit
      super
      @claim.service_provider_id = nil if @claim.host_provider_id == @claim.service_provider_id
      @claim.cost_organisation_id = nil if @claim.organisation_id == @claim.cost_organisation_id
    end    
    
    # list claims by page_no
    def list
      @claim_filter = ClaimFilter.new(params[:claim_filter])
      @claim_filter.organisation_id = nil  # filter shared with organisation
      if params[:page_no].blank?
        # Just clicked on List, No specific page. Reset the filter and save to session
        @claim_filter.save_to_session(session,:claim_filter)
        params[:page_no] = 0
      else
        @claim_filter.restore_from_session(session,:claim_filter)
      end
      params[:page_no] = params[:page_no].to_i
      @claims = Claim.find_by_filter(@claim_filter,params[:page_no])
    end
    
    # download claims using previous filter or just for single claim
    def csv
      claim_filter = ClaimFilter.new()
      if params[:id]
        claim_filter.claim_id = params[:id].to_i
      else
        claim_filter.restore_from_session(session,:claim_filter)
      end
      content_type = ( request.user_agent =~ /windows/i ?  'application/vnd.ms-excel' : 'text/csv' )
      content = Claim.csv_by_filter(claim_filter, User.cache(session[:user_id]).show_name_address_csv )
      send_data(content,:type => content_type, :filename => 'claims.csv' )
    end
    
    # list claims on hold
    def held
      params[:page_no] = 0 if params[:page_no].blank?
      params[:page_no] = params[:page_no].to_i
      @claims = Claim.held(params[:page_no])
    end
    
  
    # check have a patient, default date to today and accepted
    def after_new
      @claim.patient_id = params[:patient_id]
      if (@claim.patient_id.blank?)
        flash[:alert] = 'Please find a patient'
        redirect_to :controller => 'patient', :action => 'search'
        return
      end
      @claim.programme_id = params[:programme_id].to_i unless params[:programme_id].blank?
      
      @claim.invoice_date = Date.today
      #@claim.date_of_service = @claim.claim_date
      @claim.claim_status_id = ClaimStatus::ACCEPTED
      @claim.organisation_id = @claim.patient.organisation_id
      if ( @claim.organisation_id.blank? )
        # Dont have patient enrolled, Look at latest transaction, where marked as is_a_practice_service and use that.
       look=Claim.find(:first, :conditions => ['patient_id = ? and is_a_practice_service = 1 and claim_status_id < 8',@claim.patient_id], :joins => :fee_schedule, :order => 'invoice_date desc')        
       @claim.organisation_id = look.organisation_id if look
      end
      @claim.cost_organisation_id = @claim.organisation_id

    end 
    
    # before saving, See if the "Undo Payment:" button was clicked.
    # if so clear (set to 0) the payment_run. 
    def before_save()
     if ( params[:undopayment] )
         flash[:alert] = 'Paid Flag Cleared !!!'
         @claim.payment_run_id = 0
     end
     return true
    end
    
    # redirect to show and save the organisation_id in the session
    def after_save(ok)
      p=params[:claims_data]
      unless p.blank?
        data=@claim.data
        data.attributes=p
        data.save! if ok
      end
      if ok
        access_log( @claim.patient_id, @claim.id )
        redirect_to :controller => 'patient',  :action => 'show', :id => @claim.patient_id
      end
      
      session[:organisation_id] = @claim.organisation_id
      ok
    end    
    
    # organisation has changed, re-render the providers selects and new divs
    def xhd_organisation_change
      render :update do |page|
        c=Claim.new
        c.organisation_id = params[:organisation_id]
        
        page.replace_html 'host_provider_select_div',:partial => 'host_provider_select', :object => c
        page.replace_html 'service_provider_select_div',:partial => 'service_provider_select', :object => c
        page.replace_html 'host_provider_new_div', { :inline => '' } # Render :text always returns blank!!
        if c.organisation.not_gst_registered
          page.show 'not_gst_registered'
        else
          page.hide 'not_gst_registered'
        end
      end         
    end    
    
    # user clicked on new provider button, blank selects and render new provider
    def xhd_host_provider_new
      render :update do |page|
        p=Provider.new
        p.organisation_id = params[:organisation_id]
        page.replace_html 'host_provider_new_div',:partial => 'host_provider_new', :object => p
        page.replace_html 'host_provider_select_div', { :inline => '' }
        page.replace_html 'service_provider_select_div', { :inline => '' }
      end         
    end

    # user change the programme
    def xhd_programme_change
      render :update do |page|
        c=Claim.new if params[:claim_id].blank? 
        c=Claim.find params[:claim_id] unless params[:claim_id].blank? 
        c.programme_id=params[:programme_id].to_i
        page.replace_html 'claim_data_div', :partial => 'data_view', 
                  :object => c, :locals => { :options => { :edit_mode => true }}
      end         
    end
        
    

# = lodge    
#
# == lodge a claim from a 3rd party/legacy system (via a xmlhttp request) using REST (not SOAP)
#
# Content-Type is 'application/xml'
#
# returns status 200 on success, 500 on failure (with the body containing the exception details)
#
# The following xml structure is expected, items marked with [R] are required.
# (dates are expected to be formated as  yyyy-mm-dd or yyyy)
#
# If claim/update = "elems" - Then this is a seperate message to update previous claim data elements
#
# <post>
#   <organisation>
#     <hlink>bbfd</hlink> [R] OR phone.. [R] or name 
#     <phone>555 1234</phone>
#     <name>Browns Bay Family</name>
#   </organisation>
#   <claim>
#     <invoice_date>2006-01-18</invoice_date>
#     <invoice_no>59698</invoice_no>
#     <date_service>2006-01-18</date_service>
#     <update>elems</update>
#     <programme_code>DIAB</programme_code> [R]
#     <fee_schedule_code></fee_schedule_code>
#     <amount></amount>
#     <clinical_information></clinical_information>
#     <huhc_holder>y/t/1<huhc_holder>
#   </claim>
#   <host_provider>
#     <registration_no>16378</registration_no> [R]
#     <registration_body>NZMC</registration_body>
#     <name></name> OR family_name.. 
#     <family_name></family_name><given_names></given_names>
#   </host_provider>
#   <service_provider>
#     <registration_no>1600</registration_no> [R]
#     <registration_body>NZNC</registration_body>
#     <name></name> OR family_name.. 
#     <family_name></family_name><given_names></given_names>
#   </service_provider>
#   <patient>
#     <nhi_no>BAA2868</nhi_no> [R] OR family_name..
#     <family_name>CAMPBELL</family_name>
#     <given_names>PATRICK JOHN</given_names>
#     <date_of_birth>1938-01-30</date_of_birth> [R]
#     <gender>M</gender>
#     <ethnicity>11</ethnicity>
#     <quintile></quintile>
#     <dhb></dhb>
#   </patient>
#   <elems>
#     <code>diab</code>
#     <value>Type 2</value>
#     <description>Type of Diabetes</description>
#     <datatype>diab</datatype> // i=integer,d=date(yyyy-mm-dd),m=money/decimal,b=boolean(0/1) or s=string
#   </elems>
#   <elems>
#     <code>yodd</code>
#     <value>1995</value>
#     <description>Year of Diabetes Diagnosis</description>
#   </elems>
#   .. etc ...
# </post>
#
#
    
    def lodge
       begin
         post=params[:post];
         
         
         # Find the organisation
         organisation=nil
         organisation=Organisation.find_or_add( post['organisation'] ) unless post['organisation'].blank?
         raise ArgumentError, "Cannot find organisation" if organisation.blank?
         
         # If dont have registration no, use 00000 and Unknown
         if ( ! post['host_provider'].blank? )
           if ( post['host_provider']['registration_no'].blank? ) 
             post['host_provider']['registration_no'] = '000000'
             post['host_provider']['name'] = 'Unknown'
           end
         end
         
         # Find the providers
         host_provider=Provider.find_or_add(post['host_provider'].merge( { :organisation_id => organisation.id } ))  unless post['host_provider'].blank?
         # Find service provider
         service_provider=Provider.find_or_add(post['service_provider'].merge( { :organisation_id => organisation.id } ))  unless post['service_provider'].blank?
         # default one to the other if blank
         host_provider ||= service_provider
         service_provider ||= host_provider
         
         unless post['patient'].blank?
           # Assign the patients organisation !!
           post['patient'].store(:organisation_id,organisation.id) # remember patients organisation for the find_or_add
         end
         
         # logger.info("PATIENT="+post['patient'].inspect);
         
         
         # find the patient
         patient = Patient.find_or_add(post['patient']) unless post['patient'].blank?
         raise ArgumentError, "Patient NHI/DOB or NAME/DOB  missing" if patient.blank?
         

         claim_p=post['claim']
         raise ArgumentError, "Claim details missing" if claim_p.blank?
         
         # find the Programme
         raise ArgumentError, "Programme Code not specified" if claim_p['programme_code'].blank?
         programme = Programme.find_by_code(claim_p['programme_code'])
         raise ArgumentError, "Programme Not Found, code='#{claim_p['programme_code']}' " if programme.blank?
         # Extract Claim information
         invoice_date = Date.DateParseYyyyMmDd(claim_p[:invoice_date]) unless claim_p[:invoice_date].blank?
         date_service = Date.DateParseYyyyMmDd(claim_p[:date_service]) unless claim_p[:date_service].blank?
         invoice_no = claim_p[:invoice_no].strip[0,18].upcase unless claim_p[:invoice_no].blank?
         # default dates one for the other if blank
         invoice_date ||= date_service
         date_service ||= invoice_date
         # default dates to today, if blank
         invoice_date ||= Date.today
         date_service ||= Date.today

         
         if ( claim_p[:update] == 'elems' )
           # Special update message for claim elements, only 
           claim = Claim.find(:first, :conditions => { :patient_id => patient.id, :programme_id => programme.id, :organisation_id => organisation.id }, :order => 'invoice_date desc' )
           raise ArgumentError, "No previous claims for programme" if ( claim.blank? )
         else
           # Original amount codeline from MS
           # amount = claim_p[:amount].to_f unless claim_p[:amount].blank?
           
           # New or re-sent claim
           
           #
           # TODO: Insert a script for CVDNDIAB v.3 form, to enable users to claim a variable amount from the form, but passing thru two programmes in one claims file.
           # 1. grab amount and attached it to the programme.fee_schedule_code that contains "CP", and disregard the amount for the other fee_schedule_code
           #

           # find fee schedule by code
           fee_schedule=FeeSchedule.find(:first, :conditions => { :programme_id => programme.id, :code => claim_p[:fee_schedule_code] }) unless claim_p[:fee_schedule_code].blank?
           # fee schedule not found/not present use default 
           fee_schedule=FeeSchedule.find(:first, :conditions => { :programme_id => programme.id, :is_the_default => true, :deleted => false } )  if fee_schedule.blank?
           raise ArgumentError, "Fee Schedule Not Found (No Default), code = '#{claim_p[:fee_schedule_code]}'" if fee_schedule.blank?
           
           # TODO: we can use this line below to ~user default set in eclaims~ for NF || NC fee_schedule_code(s) - markguadalupe
           # use default amount, unless specified
           
           if ( fee_schedule.code =~ /^(CVDMP|CVDMPD|CVDMF|CVDNC|CVDRANF|CVDCPNF|DINF|DIDC|DIARNF|DIAFNF)$/ )
             amount = fee_schedule.fee
           elsif ( fee_schedule.code =~ /^(CVDRA|CVDRP|CVDRAD|CVDRPD)$/ ) && ( claim_p[:amount].to_f > 26 )
             amount = fee_schedule.fee
           
           elsif ( fee_schedule.code =~ /^(CVDCP|DIARCP|DIAFCP)$/ )
             
             #if ( claim_p[:cvddiab_service_code1] =~ /^(DINF|DIDC|DIARNF|DIAFNF|NOCLAIM)$/ ) || ( claim_p[:cvddiab_service_code2] =~ /^(CVDMP|CVDMPD|CVDMF|CVDNC|CVDRANF|CVDCPNF|NOCLAIM)$/ )
             
             if ( claim_p[:amount].to_f < 52 )
               amount = claim_p[:amount].to_f unless claim_p[:amount].blank?
             else
               amount = (claim_p[:amount].to_f - 26) unless claim_p[:amount].blank?
             end
           
           elsif ( claim_p[:amount].blank? )
             amount = fee_schedule.fee   
           else
             amount = claim_p[:amount].to_f unless claim_p[:amount].blank?
           end
           
                      
           # See if claim already exists, and update it
           # Assumes only, One claim/day/patient/organisation for each service
           if ( invoice_no.blank? )
             claim = Claim.find(:first, :conditions => { :patient_id => patient.id, :date_service => date_service, :programme_id => programme.id, :organisation_id => organisation.id }, :order => 'invoice_date desc' )
           else
             claim = Claim.find(:first, :conditions => { :patient_id => patient.id, :date_service => date_service, :programme_id => programme.id, :organisation_id => organisation.id, :invoice_no => invoice_no }, :order => 'invoice_date desc' )
           end
           if ( claim.blank? )
             claim = Claim.new
             claim.organisation_id = organisation.id
             claim.patient_id = patient.id
             claim.date_service = date_service
             claim.programme_id = programme.id
             claim.payment_run_id = 0
             claim.date_lodged = Date.today
             claim.claim_status_id = ClaimStatus::ACCEPTED
             claim.claim_status_id = fee_schedule.on_new_claim_status_id unless fee_schedule.on_new_claim_status_id.blank?
             claim.comment = fee_schedule.on_new_claim_comment unless fee_schedule.on_new_claim_comment.blank?
             claim.claim_status_id = organisation.on_new_claim_status_id unless organisation.on_new_claim_status_id.blank?
             claim.comment = organisation.on_new_claim_comment unless organisation.on_new_claim_comment.blank?
             
             # Reject test nhi_no's. TODO: move this list into the database
             if ( patient.nhi_no =~ /^(ABC1235|ABC1345|ABC1346|AAA9999|ABC0000|AAA0000|ABC9999|XYZ9999|XYZ1235|XXX9999|XXX1235)$/ )
               claim.claim_status_id = ClaimStatus::DELETED
               claim.comment = 'test claim';
             end
           end
           claim.invoice_date = invoice_date
           claim.invoice_no = invoice_no
           claim.fee_schedule_id = fee_schedule.id
           claim.amount = amount unless claim.payment_run_id > 1 # DONT change amount if paid !!!!
           claim.host_provider_id = host_provider.id unless host_provider.blank?
           claim.service_provider_id = service_provider.id  unless service_provider.blank?

           claim.clinical_information = claim_p[:clinical_information] unless claim_p[:clinical_information].blank?
           # claim.clinical_information = claim_p[:cvddiab_service_code1]

           # set cplus and huhc status at time of claim !!!
           claim.cplus_enrolled = 1 if patient.is_care_plus > 0
           # If data sent anonomosuly and want huhc status, you must place it on the claim form.
           claim.huhc_holder = 1 if claim_p[:huhc_holder] =~ /^y|^t|^1/i 
           
           unless claim.claim_status_id == ClaimStatus::DELETED
             # Check not more than 1 claim on the same day. 
             unless programme.same_day_claim_status_id.blank?
                cid = claim.id
                cid = 0 if cid.blank?
                dup = Claim.find(:first, :conditions => [ "patient_id = ? and date_service = ? and programme_id = ? and organisation_id = ? and claim_status_id < ? and id <> ?",
                                         patient.id, date_service, programme.id, organisation.id, ClaimStatus::DELETED, cid], :order => 'invoice_date desc' )             
                if dup 
                  claim.claim_status_id = programme.same_day_claim_status_id 
                  claim.comment = programme.same_day_claim_comment
                end
             end
             
             if claim.amount.to_f > 0  # Multiple Zero value claims are OK. (When looking at claim limit ignore $0 claims)  
              unless programme.claim_limit_claim_status_id.blank? || programme.claim_limit_count.blank? || programme.claim_limit_period_mths.blank?
                cid = claim.id
                cid = 0 if cid.blank?
                mago = date_service.months_ago(programme.claim_limit_period_mths)
                # For care plus, this is from your cplus annerversary # BUT dont store this !!!
                hists = Claim.find(:all, :conditions => [ "patient_id = ? and date_service > ? and date_service <= ? and programme_id = ? and organisation_id = ? and claim_status_id < ? and amount > 0.00 and id <> ?",
                                         patient.id, mago, date_service, programme.id, organisation.id, ClaimStatus::DELETED, cid], :order => 'invoice_date desc' )             
                if hists.length >= programme.claim_limit_count 
                  claim.claim_status_id = programme.claim_limit_claim_status_id
                  claim.comment = programme.claim_limit_claim_comment
                end
              end
             end
           end

           
           claim.save!
         end

         elems_p=post['elems']
         if ( elems_p )
           # OLD: Get the class for the code, e.g. "DiabElem"
           # OLD: elem_class = "#{programme.code.capitalize}Elem".to_class # note:: to_class is an extension of String. uses: Kernel.const_get(self.camelcase)
           data_columns = ClaimsData.columns
           
           elems_p=[elems_p] if elems_p.class != Array # Fix-up. if only one elems, then "elems_p" is a Hash not an Array !!
           
           # create the instance elem
           elem = ClaimsData.find_by_id(claim.id);
           if ( elem.blank? )
             elem = ClaimsData.new
             elem.id = claim.id # use the same id
           end

           # create code hash-map => { :name => 'column-name', :type => :column_type, :limit => size }
           code_map = {}
           elems_p.each do |e|
             # extract code/value for each elem 
             
             code = e['code'] 
             unless code.blank? 
               # find column starting with code_ or the full name 
               match = Regexp.new('^'+code+'[_].*')
               col = data_columns.find { |f| match =~ f.name || code == f.name  }
               if col
                 code_map[code] = { :name => col.name, :type => col.type, :limit => col.limit }
               else
                 logger.info("INFORMATION: claim/post '#{code}' not found");
                 # TODO: Add column to DB
               end
             end
           end
           
           # assign the values
           elems_p.each do |e|
             # extract code/value for each elem 
             code = e['code']
             value = e['value']
             value.strip! unless value.blank? # just incase get cr/lf or extra spaces
             value.gsub!('\\','/') unless value.blank? # MS: 2011-12-02 - SQL does not escape a string ending "\" correctly, work around !! 
             value = nil if value.blank?
             unless code.blank? 
               mapc = code_map[code]
               if ( mapc )
                 

                 # Match on a column. Convert to correct type
                 if value
                   case mapc[:type]
                     when :decimal
                       value=value.to_f
                     when :string
                       value=value[0,mapc[:limit]]
                     when :integer
                       if value =~ /^y|^t/i   # map YES/TRUE
                         value=1
                       else
                         value=value.to_i
                       end
                     when :boolean
                       if value =~ /^y|^t/i   # map YES/TRUE
                         value=true
                       else
                         value=( value.to_i > 0 )
                       end
                     when :date, :datetime
                       begin
                         value=Date.DateParseYyyyMmDd(value)
                       rescue Exception => e
                         value=nil
                       end
                   end
                 end
                 # Finally assign it
                 elem.send(mapc[:name]+'=',value)
               end
             end
           end
           elem.save!
         end
         render :text => claim.id.to_s
       rescue Exception => e
         render :text => "#{e.class.to_s}:: #{e}", :status => 500
       end
    end

    def ping
       render :text => 'ok'
    end
    
end
