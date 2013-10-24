class Admin::FeeScheduleController < ApplicationController
    # uses base controller for most of the work
    layout 'admin'
    before_filter :check_role_claims_admin, :only => [ :edit, :new, :post ]
    
    
    RECORD_CLASS = FeeSchedule
    
    # assigns the programme_id
    def after_new
      @fee_schedule.programme_id = params[:programme_id]
      # @fee_schedule.is_a_entry_service = 1 # The DB Default
    end
    
    # redirect to programme/show
    def after_save(cc)
      redirect_to :controller => 'programme',  :action => 'show', :id => @fee_schedule.programme_id if cc
    end
        
    
end
