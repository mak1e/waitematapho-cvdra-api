class Admin::ProgrammeController < ApplicationController
    layout 'admin'
    
    RECORD_CLASS = Programme
    
    before_filter :check_role_claims_admin, :only => [ :edit, :new, :post ]
    
    # Select Data elements
    def elements
      @programme = Programme.find(params[:id]);
    end
    
    # Update Elements (columns) to Display
    def post_elements
      programme_id = params[:programme][:id]
      ProgrammeElement.destroy_all ['programme_id = ?', programme_id ]
      logger.info("programme=#{programme_id}");
      logger.info(params.inspect);
      
      pelist = params[:programme_elements]
      # Add in the new items. From params return if OK. 
      index=0;
      while ( pelist[index.to_s] )
        cn=pelist[index.to_s][:column_name]
        unless cn.blank?
           pe=ProgrammeElement.new( pelist[index.to_s] )
           pe.programme_id = programme_id
           pe.position = index
           # pe.column_name = cn # assigned in the new above !!
           pe.save!
        end
        index += 1;
      end
      redirect_to :action => 'show', :id => programme_id
    end

       
end
