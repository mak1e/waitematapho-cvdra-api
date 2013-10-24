# == Schema Information
# 
#
# Table name: claim_statuses
# 
# Active Record without a table. Used to filter claims 
# 
# NOTE: Dont store ActiveRecord in a session, Messes up ActiveRecord


class ClaimFilter < ActiveRecord::BaseWithoutTable
   column 'invoice_date_start', :date
   column 'invoice_date_end', :date
   column 'date_service_start', :date
   column 'date_service_end', :date
   column 'programme_id', :integer
   column 'fee_schedule_id', :integer
   column 'organisation_id', :integer
   column 'claim_status_id', :integer
   column 'zero_value', :integer
   column 'invoice_no', :string
   column 'claim_id', :integer
   column 'order_by', :string

   belongs_to :programme
   belongs_to :fee_schedule     
   belongs_to :organisation
   belongs_to :claim_status
     
  # Return conditions array suitable for Claim.find
  # The existing conditions as [ "sql", value, value ...] is passed in
  def build_conditions(conditions)
      conditions = ["1=1"] if conditions.blank?
      unless self.claim_id.blank?
          conditions[0] += " and id = ?"
          conditions << self.claim_id
      end
      unless self.organisation_id.blank?
          conditions[0] += " and organisation_id = ?"
          conditions << self.organisation_id
      end
      unless self.date_service_start.blank?
          conditions[0] += " and date_service >= ?"
          conditions << self.date_service_start
      end
      unless self.date_service_end.blank?
          conditions[0] += " and date_service <= ?"
          conditions << self.date_service_end
      end
      unless self.invoice_date_start.blank?
          conditions[0] += " and invoice_date >= ?"
          conditions << self.invoice_date_start
      end
      unless self.invoice_date_end.blank?
          conditions[0] += " and invoice_date <= ?"
          conditions << self.invoice_date_end
      end
      unless self.programme_id.blank?
          conditions[0] += " and programme_id = ?"
          conditions << self.programme_id
      end
      unless self.fee_schedule_id.blank?
          conditions[0] += " and fee_schedule_id = ?"
          conditions << self.fee_schedule_id
      end
      unless self.claim_status_id.blank?
          conditions[0] += " and claim_status_id = ?"
          conditions << self.claim_status_id
      end
      unless self.invoice_no.blank?
          conditions[0] += " and invoice_no = ?"
          conditions << self.invoice_no
      end
      if self.zero_value == 1 
          conditions[0] += " and amount = 0"
      end
      conditions
  end  
  
   # Save attributes into the session, hash
   def save_to_session(session,key)
     session[key] ||= {}
     ClaimFilter.columns.each do |c|
       session[key][c.name.to_sym] = self.read_attribute(c.name)
     end
     nil
   end
   
   def restore_from_session(session,key)
     if session[key] 
       ClaimFilter.columns.each do |c|
         self.write_attribute(c.name,session[key][c.name.to_sym])
       end
     end
     nil
   end  
  
  def self.order_by_choices_for_select()
    [['Invoice Date','invoice_date desc'],['Service Date','date_service desc']]
  end       
     
end
  
