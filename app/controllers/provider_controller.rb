class ProviderController < ApplicationController
    layout 'default'
    
    RECORD_CLASS = Provider  
    
    def after_new
      @provider.organisation_id = params[:organisation_id]
    end
    
    def after_save(cc)
      redirect_to :controller => '/organisation',  :action => 'show_providers', :id => @provider.organisation_id if cc
    end
    
    
end
