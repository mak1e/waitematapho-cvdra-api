# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '9180354a33d3922a8ee49f0174380e0f'
  
  filter_parameter_logging :password
  
  before_filter :logged_in
  
  def logged_in
    if ( ! session[:user_id] ) # by-pass security if development
      if ( ENV['RAILS_ENV'] == 'development' ) || ( ENV['RAILS_ENV'] == 'production' ) # added production only for the Predict API connection
        session[:user_id] = 1
      end
    end
  
    unless session[:user_id] 
       render :file => "public/401.html", :layout => false, :status => 401
    end
  end
  
  # Check person is system admin otherwise, status 401 
  def check_role_system_admin
    render :file => "public/401.html", :layout => false, :status => 401 unless User.cache(session[:user_id]).role_system_admin
  end

  def check_role_claims_admin
    render :file => "public/401.html", :layout => false, :status => 401 unless User.cache(session[:user_id]).role_claims_admin
  end

  def check_role_claims_processing
    render :file => "public/401.html", :layout => false, :status => 401 unless User.cache(session[:user_id]).role_claims_processing
  end
  
  def check_role_payment_processing
    render :file => "public/401.html", :layout => false, :status => 401 unless User.cache(session[:user_id]).role_payment_processing
  end
  
  
  # show model sets instance variable
  def show
    instance_variable_set("@#{self.class::RECORD_CLASS.to_s.underscore}",
       self.class::RECORD_CLASS.find(params[:id]))
  end

  def edit
    instance_variable_set("@#{self.class::RECORD_CLASS.to_s.underscore}",
       self.class::RECORD_CLASS.find(params[:id]))
  end

  def new
    instance_variable_set("@#{self.class::RECORD_CLASS.to_s.underscore}",
       self.class::RECORD_CLASS.new)
    self.after_new if self.respond_to?('after_new')
    render :action => 'edit' unless performed?
  end

  # post/save data to the model. then calls show or edit (on fail)
  #
  # call backs are as follows :-
  # * *before_save* called just before save, return false to cancel the save
  # * *after_save*(ok) called just after the save, return false to envoke edit rather than show. (Note record is not deleted from the database)
  def post
    data = params[self.class::RECORD_CLASS.to_s.underscore]
    
    id = data[:id]
    if ( id.blank? )
      record = self.class::RECORD_CLASS.new
    else
      record = self.class::RECORD_CLASS.find(id)    
    end
    record.attributes = data
    instance_variable_set("@#{self.class::RECORD_CLASS.to_s.underscore}", record )
    
    ok=true
    ok=self.before_save() if self.respond_to?('before_save')
    ok=record.save if ok
    ok=self.after_save(ok) if self.respond_to?('after_save')
    
    if ok
       redirect_to :action => 'show', :id => record.id unless performed?
    else
       render :action => 'edit' unless performed?
    end
  end  
  
  # list record by id (or position) if present
  def list
    order_col_name = self.class::RECORD_CLASS.columns_hash['position'] ? 'position' : 'id'
    instance_variable_set("@#{self.class::RECORD_CLASS.to_s.underscore.pluralize}",
       self.class::RECORD_CLASS.find(:all,:order => order_col_name ))
   
  end
 
  # add access to the patient/claim_id
  def access_log( patient_id, claim_id )
    if ( session[:logged_patient_id] != patient_id ) || (( session[:logged_claim_id] != claim_id )  && (!claim_id.blank?))
       # Have not logged this already. 
       al=AccessLog.new
       al.user_id = session[:user_id]
       al.patient_id = patient_id
       al.claim_id = claim_id
       al.save!
       session[:logged_patient_id] = patient_id
       session[:logged_claim_id] = claim_id
    end
  end
  
  require 'win32/process'
  
  # run a script in the background !!
  def script_runner( cmd )
#     logger.info "script/runner #{cmd}"
     Process.create(
#            :app_name         => "notepad script/runner -e #{ENV['RAILS_ENV']} #{cmd}",
            :app_name         => "ruby script/runner -e #{ENV['RAILS_ENV']} #{cmd}",
            :creation_flags   => Process::DETACHED_PROCESS,
            :process_inherit  => false,
            :thread_inherit   => false,
            :cwd              => RAILS_ROOT )
  end

  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
end
