class Admin::DataFieldController < ApplicationController
    layout 'admin'
   # before_filter :check_role_claims_admin, :only => [ :edit, :new, :post ]
    
    
    RECORD_CLASS = DataField
    
  def list
    DataField.populate_table
    
    order_col_name = self.class::RECORD_CLASS.columns_hash['position'] ? 'position' : 'id'
    @data_fields=DataField.find(:all,:order => 'label' );
  end    
  
  def after_save(cc)
    redirect_to :action => 'list' if cc
  end  
end
