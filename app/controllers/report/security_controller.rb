class Report::SecurityController < Report::BaseController

  def log
    # Show the security log
    params[:page_no] = 0 if params[:page_no].blank?
    params[:page_no] = params[:page_no].to_i
    @logs = AccessLog.find_by_page(params[:page_no])
  end 
  
end
