class Admin::AdvController < ApplicationController
  layout 'admin'
         
  caches_page  :nhi  
  skip_before_filter :verify_authenticity_token, :only => [ :nhi ]

  before_filter :check_role_claims_admin, :only => [ :asr, :upload_register, :bulk_hold, :bulk_accept, :bulk_reprice ]
  before_filter :check_role_system_admin, :only => [ :sql  ]
  
  require 'zip/zipfilesystem'
  require 'json'
  
  class Criteria < ActiveRecord::BaseWithoutTable
     column 'programme_id', :integer
     column 'from_date', :date
     column 'to_date', :date
     
     column 'organisation_id', :integer
     column 'duplicate_organisation_id', :integer
     
     column 'provider_id', :integer
     column 'duplicate_provider_id', :integer
  end
  
  def index
      @criteria = Criteria.new
      @criteria.from_date = Date.current.beginning_of_quarter
      @criteria.to_date = Date.current.end_of_quarter.next
  end
  
  def xhd_index_organisation_change
      render :update do |page|
        c=Criteria.new
        c.organisation_id = params[:organisation_id]
        page.replace_html 'index_change_provider_select_div',:partial => 'index_change_provider_select', :object => c
      end         
   end    
 
  
  def asr
  end
  
  def upload_register
    asr=params['asr'];
    if asr.blank?
      flash[:alert] = 'No File Specified'
      redirect_to :controller => '/home',  :action => 'index'
      return
    end
    logger.info "ASR.class=#{asr.class.to_s}"
    
    tmp_asr = File.join(RAILS_ROOT,'tmp','CBFHL7OUT.asr')
    
    # Class should be a TempFile/UploadedTempfile object if file is large. > 10k
    File.delete(tmp_asr) if File.exists?(tmp_asr)
    
    if asr.original_filename =~ /\.zip$/i
      Zip::ZipFile.open(asr.local_path) do |zipfile|
        zipfile.extract( zipfile.entries[0], tmp_asr)
      end
    else
       FileUtils.copy asr.local_path, tmp_asr
    end
    
    
    Registry.write_string(Registry::ASR_SECTION,Registry::ASR_STATUS_IDENT,"ASR Uploaded, Waiting for processing to start  #{Time.now}")
    flash[:alert] = "File has been uploaded to the server, processing will start in approx 1 minute. Refresh this page to view updated status.";

    script_runner('Patient.update_from_asr')

    redirect_to  :action => 'asr'
  end
  
  
  # Place claims on hold, for specified criteria.programme_id, where invoiced on after criteria.date
  def bulk_hold
    flash[:alert] = "Claims placed on hold. "
    @criteria = Criteria.new(params[:criteria])
    Claim.update_all("claim_status_id = #{ClaimStatus::HELD}",
                     ["programme_id = ? and invoice_date >= ? and ( claim_status_id = ? OR claim_status_id = ? ) and payment_run_id <= 1",
                               @criteria.programme_id,  @criteria.from_date, ClaimStatus::BORDERLINE, ClaimStatus::ACCEPTED ] )
    redirect_to :controller => '/claim',  :action => 'held'
  end
  
  # Accept on hold Claims, for specified criteria.programme_id, where invoiced before (not including) criteria.date
  def bulk_accept
    flash[:alert] = "On Hold claims now accepted. "
    @criteria = Criteria.new(params[:criteria])
    Claim.update_all("claim_status_id = #{ClaimStatus::ACCEPTED}",
                     ["programme_id = ? and  invoice_date >= ? and invoice_date < ? and claim_status_id = ?  and payment_run_id <= 1",
                               @criteria.programme_id,  @criteria.from_date, @criteria.to_date, ClaimStatus::HELD ] )
    redirect_to :controller => '/claim',  :action => 'held'
  end
  
  # Re-price (un-paid) claims based on new fee schedule, for specified criteria.programme_id, where invoiced on/after  criteria.date
  def bulk_reprice
    flash[:alert] = "Claims now re-priced. "
    @criteria = Criteria.new(params[:criteria])
    Claim.update_all("amount = ( select fee from fee_schedules where fee_schedules.id = claims.fee_schedule_id )",
                     ["programme_id = ? and invoice_date >= ? and payment_run_id <= 1",
                               @criteria.programme_id,  @criteria.from_date ] )
    redirect_to :controller => '/claim',  :action => 'list'
  end
  
  def merge_organisations
    @criteria = Criteria.new(params[:criteria])
    if ( @criteria.organisation_id.blank? || @criteria.duplicate_organisation_id.blank? ||
         @criteria.organisation_id == @criteria.duplicate_organisation_id )
      flash[:alert] = "Please specify the organisations. "
      render :action => 'index'       
      return
    end
    
    # Change the organisation_id of the providers in "duplicate" if don't already exist in "master"
    Provider.update_all(
      "organisation_id = #{@criteria.organisation_id}",
      "id in (\n"+
      "  select dup.id\n"+
      "  from providers dup\n"+
      "    left join providers mast\n"+
      "      on mast.registration_no = dup.registration_no and mast.organisation_id = #{@criteria.organisation_id}\n"+
      "  where dup.organisation_id = #{@criteria.duplicate_organisation_id} and mast.id is null )")
       
    # Change provider_id in Claims where "duplicate" providers already exist in "master", then remove provider
    move_providers = Provider.find_by_sql(
      "select mast.id provider_id, dup.id duplicate_provider_id, dup.name\n"+
      "from providers dup\n"+
      "  left join providers mast\n"+
      "      on mast.registration_no = dup.registration_no and mast.organisation_id = #{@criteria.organisation_id}\n"+
      "where dup.organisation_id = #{@criteria.duplicate_organisation_id} and mast.id is not null")
    move_providers.each do |e|
      Claim.update_all( "host_provider_id = #{e.provider_id}",
                        "host_provider_id = #{e.duplicate_provider_id}")
      Claim.update_all( "service_provider_id = #{e.provider_id}",
                        "service_provider_id = #{e.duplicate_provider_id}")
      Provider.delete_all( "id = #{e.duplicate_provider_id}" )
    end
    
    # Change the organisation_id in the claims to match.
    Claim.update_all("organisation_id = #{@criteria.organisation_id}","organisation_id = #{@criteria.duplicate_organisation_id}")
    Claim.update_all("cost_organisation_id = #{@criteria.organisation_id}","cost_organisation_id = #{@criteria.duplicate_organisation_id}")
    Patient.update_all("organisation_id = #{@criteria.organisation_id}","organisation_id = #{@criteria.duplicate_organisation_id}")
    # Finally delete the organisation
    Organisation.delete_all("id = #{@criteria.duplicate_organisation_id}")
    # Clean up Budgets
    Budget.prepopulate_budgets; 
      
    flash[:alert] = "Merge Complete. "
    redirect_to :controller => '/organisation',  :action => 'list'
  end
  
  def merge_providers
    @criteria = Criteria.new(params[:criteria])
    if ( @criteria.organisation_id.blank? || @criteria.provider_id.blank? || @criteria.duplicate_provider_id.blank? 
         @criteria.provider_id == @criteria.duplicate_provider_id )
      flash[:alert] = "Please specify the providers. "
      render :action => 'index'       
      return
    end
    Claim.update_all( "host_provider_id = #{@criteria.provider_id}",
                        "host_provider_id = #{@criteria.duplicate_provider_id}")
    Claim.update_all( "service_provider_id = #{@criteria.provider_id}",
                        "service_provider_id = #{@criteria.duplicate_provider_id}")
    Provider.delete_all( "id = #{@criteria.duplicate_provider_id}" )
    flash[:alert] = "Merge Complete. "
    redirect_to :controller => '/organisation',  :action => 'show_providers', :id => @criteria.organisation_id
  end

  def sql
    @ds=nil
    @message=''
    
    
    unless params[:sql].blank?
      begin
        sql=params[:sql]
        # Add "sele
        if ( sql =~ /^select/i )
          sql.insert(7,"top 100 ") unless sql =~ /^select top /i
          @ds=Query.connection.raw_select(sql)
        elsif ( sql =~ /^update|^delete|^insert/i )
          nrows=Query.connection.update_sql(sql)
          @message="#{nrows} rows affected"
        else
          @message="Unknown command #{sql[0,7]}..."
        end
        logger.info("SQL RAN ON DATABASE #{sql}");
      rescue Exception => e
         @message = "EXCEPTION,  #{e.class.to_s}:: #{e}"
      end          
      
      
    end
  end

  
  
    
  def cplus_csv
    require 'faster_csv'
    content_type = ( request.user_agent =~ /windows/i ?  'application/vnd.ms-excel' : 'text/csv' )

    query = Query.find_by_sql([
          "select p.nhi_no, convert(varchar(10),max(c.date_service),103) max_date_service\n"+
          "from patients p\n"+
          "  left join claims c on c.patient_id = p.id\n"+
          "where p.is_care_plus = 1\n"+
          " and ( c.programme_id = #{Programme::CPLUS} or  c.programme_id = #{Programme::CPWD} or  c.programme_id = #{Programme::CPW} )\n"+
          "group by p.nhi_no\n"])
    
    content = FasterCSV.generate do |csv|
      csv << ['nhi_no','date_service']
      results=session[:results]
      for q in query do
         csv << [q.nhi_no,q.max_date_service]
      end
    end
    send_data(content,:type => content_type, :filename => 'cplus.csv' )
  end  
  
  def downloads
     @databasebackups =  Dir["C:/BACKUP/*/#{ActionController::AbstractRequest.relative_url_root}*.bak" ]
     @databasebackups.sort! { |a,b| (File.mtime(a) <=> File.mtime(b))*(-1) }
  end
 
  def file_download
    filepath=params[:filepath];
    if ( File.mtime(filepath).to_i != params[:security].to_i )
      render :text => "<h1>\'#{filepath}\' Not Found</h1>", :status => 404
    else
      send_file(filepath, :type => 'application/octet-stream', :filename => filepath.split(File::SEPARATOR).last, :stream => true )
    end
  end    
  
end
