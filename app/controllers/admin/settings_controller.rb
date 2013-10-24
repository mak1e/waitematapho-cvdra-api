class Admin::SettingsController < ApplicationController
  
    layout 'admin'
    # uses base controller for most of the work
    RECORD_CLASS = Settings
    
    # only show id=1
    def show
      params[:id] = 1
      super
    end

    # only edit id=1
    def edit
      params[:id] = 1
      super
    end
    
    # after save redirect to home
    def after_save(cc)
      redirect_to :controller => 'home',  :action => 'index' if cc
    end    
    
 
    
end
