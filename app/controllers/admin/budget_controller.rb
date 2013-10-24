class Admin::BudgetController < ApplicationController
    layout 'admin'
    
    RECORD_CLASS = Programme
    
    before_filter :check_role_claims_admin, :only => [ :edit, :show ]
    
    def show
      Budget.prepopulate_budgets 
      super
    end
    
    def after_save(cc)
      # Save all the budgets 
      if ( params[:commit] == "Clear")
        # Want to clear the budget
        @programme.budget_start = nil
        @programme.budget_method = nil
        @programme.budget_details = nil
        @programme.commit_episode = nil
        @programme.save
        Budget.delete_all( { :programme_id => @programme.id })
      else
        budgets = params[:budgets]
        budgets.each do |key,val|
          budget = Budget.find(val[:id])
          budget.budget = val[:budget];
          budget.save
        end
      end
      redirect_to :action => 'show', :id => @programme.id if cc
    end  
  
end
