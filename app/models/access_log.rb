# == Schema Information
#
# Table name: access_logs
#
#  id         :integer       not null, primary key
#  user_id    :integer       not null
#  patient_id :integer       not null
#  claim_id   :integer       
#  created_at :datetime      not null
#

class AccessLog < ActiveRecord::Base
  PAGE_SIZE=100
  
  belongs_to :patient
  belongs_to :user
  
  
  # Clear out old log entries, over 1 year old. 
  def self.purge
    self.destroy_all( [ 'created_at < ?', Time.now.last_year  ] )
  end  
  
  # Find the access log records, by id descending, by page (100 per page), if -ve page_no all records are returned
  def self.find_by_page(page_no)
    AccessLog.find(:all, :offset => ( page_no >= 0 ? page_no*(AccessLog::PAGE_SIZE) : nil ), 
                       :limit => ( page_no >= 0 ? AccessLog::PAGE_SIZE : nil ) , :order => 'id desc');
  end
  
  
end
