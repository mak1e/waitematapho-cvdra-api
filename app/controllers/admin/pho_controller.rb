class Admin::PhoController < ApplicationController
    # uses base controller for mostof the work
    layout 'admin'
    RECORD_CLASS = Pho
    before_filter :check_role_claims_admin, :only => [ :edit, :new, :post ]
    
    # list Pho's by name
    def list
      @phos = Pho.find(:all, :select=>'id, name, dhb_id, deleted ',:order=>'name'  );
    end
    
    # after save redirect to list
    def after_save(cc)
      redirect_to  :action => 'list' if cc
    end    
    
end
