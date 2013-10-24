class OrganisationController < ApplicationController
  layout 'default'
  
  RECORD_CLASS = Organisation

  def show
    super
    session[:organisation_id] = @organisation.id
    
    # need to also list the claims
    @claim_filter = ClaimFilter.new(params[:claim_filter])
    if params[:page_no].blank?
      # Just clicked on Show, No specific page. Reset the filter and save to session
      @claim_filter.save_to_session(session,:claim_filter)
      params[:page_no] = 0
    else
      @claim_filter.restore_from_session(session,:claim_filter)
    end
    params[:page_no] = params[:page_no].to_i
    
    @claim_filter.organisation_id = @organisation.id
    @filtered_claims = Claim.find_by_filter(@claim_filter,params[:page_no])    
  end
  
  # download claims using previous filter and orgaanisation_id
  def csv
    claim_filter = ClaimFilter.new()
    claim_filter.restore_from_session(session,:claim_filter)
    claim_filter.organisation_id = params[:id].to_i

    content_type = ( request.user_agent =~ /windows/i ?  'application/vnd.ms-excel' : 'text/csv' )
    content = Claim.csv_by_filter(claim_filter)
    send_data(content,:type => content_type, :filename => 'claims.csv' )
  end  
  
  def show_providers
     show
  end    
  
  
  def list
    @organisations = Organisation.find(:all,:order => 'isnull(pho_id,999), deleted, name' );
  end    
end
