class Admin::ProgrammeElementController < ApplicationController
    # uses base controller for most of the work
    layout 'admin'
    before_filter :check_role_claims_admin, :only => [ :edit, :new, :post ]
    
    RECORD_CLASS = ProgrammeElement
    
    # assigns the programme_id
    def after_new
      @programme_element.programme_id = params[:programme_id]
    end
    
    # redirect to programme/show
    def after_save(cc)
      redirect_to :controller => 'programme',  :action => 'show', :id => @programme_element.programme_id if cc
    end
    
    def post
        if params[:commit] == "Delete"
          ProgrammeElement.delete params[:programme_element][:id]
          flash[:alert] = 'Element Deleted'
          redirect_to :controller => 'programme',  :action => 'show', :id => params[:programme_element][:programme_id]
        else
          super
        end
      
    end
    

  def delete
  end        
    
end
