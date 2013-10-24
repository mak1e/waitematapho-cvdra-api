class HomeController < ApplicationController
  skip_before_filter :logged_in, :only => [:index,:login]

  layout 'default'
  
  def index
    action_name = Settings.instance.name;
    @user = nil
    if ( session[:user_id] )
      @user = User.cache(session[:user_id])
    end
    render :action => 'index'
  end     
  
  def change_password
   p=params[:user]
   # Clear out passwords, in case fault and they get dumped !!
   p_password = p[:password]
   p_password_confirm = p[:password_confirm]   
   p_old_password = p[:old_password]
   p[:password] = '********'
   p[:password_confirm] = '********'
   p[:old_password] = '********'
   
   @user = User.find(p[:id])
   if @user.blank? || ! @user.valid_password(p_old_password) 
     @user.errors.add :old_password, 'does not match existing password'
     render  :action => 'index', :id => 0 
   else
     @user.password = p_password
     @user.password_confirm = p_password_confirm
     flash[:alert] = 'Password changed' if @user.save
     render :action => 'index', :id => 0 
   end
  end
  
  
  def login
   p=params[:user]
   # Clear out passwords, in case fault and they get dumped !!
   p_password = p[:password]
   p[:password] = '********'
   
   
   user = User.find(:first, :conditions => [' username = ? and deleted = ?' , p[:username], false ])
   if user.blank? || ! user.valid_password(p_password) 
     flash[:notice] = 'Username or password invalid'
     render :action => 'index', :id => 0 
   else
     session[:user_id] = user.id
     
     redirect_to :action => 'index', :id => 0 
     user.last_login_at = Time.now
     user.save
     flash[:alert] = 'Welcome to ' + Settings.instance.name

     Session.purge # Clean up sessions / Cache
     AccessLog.purge # Clean out old log records
     # expire_fragment( :controller => :inbox, :action => :list, :part => session[:user_id] )
   end
   
  end
  
  def logout
     session[:user_id] = nil
     reset_session
     flash[:notice] = 'logged out'
     redirect_to :action => 'index', :id => 0 
  end
  
  def test
    c=Claim.find(:first, :conditions => ['patient_id = ? and is_a_practice_service = 1 and claim_status_id < 8',154188], :joins => :fee_schedule, :order => 'invoice_date desc')
    render :text => "done", :layout => false
  end  
  
end
