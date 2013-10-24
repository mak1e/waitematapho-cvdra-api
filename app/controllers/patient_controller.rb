class PatientController < ApplicationController
    layout 'default'
    before_filter :check_role_claims_processing, :only => [ :edit, :new, :post ]
    
    RECORD_CLASS = Patient
    
    def show
      super
      session[:patient_id] = @patient.id
      access_log( @patient.id, nil )
      render :action => 'show', :layout => 'popup' if params[:popup]
    end

    def nhi
      #super
      session[:patient_nhi] = @patient.nhi_no
      access_log( @patient.nhi_no, nil )
      render :action => 'nhi', :layout => 'popup' if params[:popup]
    end

        
    def after_new
      @patient.dhb_id = Settings.instance.dhb_id
    end    
    
    def list
      criteria=params[:criteria];
      if criteria.blank?
         flash[:alert] = 'Please specify some criteria'
         redirect_to :action => 'search'
      else
        criteria.upcase!
        if criteria =~ /^[0-9]{8}$/  # ddmmyyyy
          dob=Date.new(criteria[4,4].to_i,criteria[2,2].to_i,criteria[0,2].to_i)
          conditions=['date_of_birth = ?',dob] # Array [condition,value...]
        elsif criteria =~  /^[A-HJ-NP-Z]{3}[0-9]{4}$/
          @search_on = criteria
          conditions=['nhi_no = ?',criteria ]; # Array [condition,value...]
        elsif criteria =~  /^#/
          redirect_to :controller => 'claim', :action => 'list', 'claim_filter[invoice_no]'.to_sym => criteria[1,criteria.length-1]
        else 
          conditions=[''] # Array [condition,value...]
          criteria.split(' ').each do |w|  
            if ( conditions[0].blank? )
              # No Condition yet
              @search_on = w;
              conditions[0]='family_name >= ? and family_name <= ?';
              conditions << w;
              conditions << w+'Z';
            else
              @search_on += ', ' + w;
              conditions[0] += ' and ( family_name like ? or given_names like ? or given_names like ? )';
              conditions <<  '% '+w+'%';
              conditions <<  w+'%'
              conditions <<  '% '+w+'%';
            end
          end
        end
        @patients=Patient.find(:all, :conditions => conditions, :limit => 50, :order => 'family_name, given_names' )
      end
    end
    
    def dedup
      pat=Patient.find(params[:id]);
      dup=Patient.find(:first,:conditions => ['nhi_no = ? and date_of_birth = ? and id <> ? ', pat.nhi_no, pat.date_of_birth, pat.id ]);
      if ( dup.blank? )
        flash[:alert] = 'No duplicates found'
      else
        flash[:alert] = 'Duplicate removed'
        Claim.update_all("patient_id = #{pat.id}","patient_id = #{dup.id}")
        dup.destroy
      end
      redirect_to :controller => 'patient',  :action => 'show', :id => pat.id
    end
    
    def access
      @patient = Patient.find(params[:id])
    end
    
    
end
