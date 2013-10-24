# == Schema Information
#
# Table name: payment_runs
#
#  id           :integer       not null, primary key
#  cut_off_date :datetime      not null
#  payment_date :datetime      
#  user_id      :integer       not null
#  programme_id :integer       not null
#  note         :string(18)    
#  created_at   :datetime      
#  updated_at   :datetime      
#

class PaymentRun < ActiveRecord::Base
  attr_protected :id
  
  validates_length_of :note, :maximum => 18, :allow_nil => true
  validates_presence_of :cut_off_date
  validates_presence_of :programme_id
  
  belongs_to :programme
  
  has_many :claims, :order => 'invoice_date desc'  
  
  def self.caption_for_id(id)
    id > 1 ? "YES\##{ '%4.4i' % id}" : '-'
  end
  
  def caption
    # Return heading for a payment run
    if ( self.id.blank? )
      'NEW Payment Run'
    elsif  ( self.id == 1 )
      'Preview'
    else
      'RUN-%4.4i' % self.id
    end
  end   
  
  # returns summary of payment by organisation.
  # fields returned are organisation_id,organisation_name, organisation_suburb, not_gst_registered, sumamount
  def by_organisation
    query = Query.find_by_sql(
      "select o.id organisation_id, o.name organisation_name,o.residential_suburb organisation_suburb, o.not_gst_registered, sum(c.amount) sumamount\n"+
      "from claims c\n"+
      "  join organisations o on o.id = c.organisation_id\n"+
      "where c.payment_run_id = #{self.id}\n"+
      "group by o.id, o.name,o.residential_suburb,o.not_gst_registered\n"+
      "order by 2")
    query
  end
  
  # returns summary of payment by organisation and host_provider (only where provider paid seperately)
  # NOTE: host_provider_id of null, this represents payment to the organisation (not provider)
  # fields returned are organisation_id, organisation_name, organisation_suburb, host_provider_id, host_provider_name, not_gst_registered, sumamount
  def by_organisation_and_host_provider_pre_GST
    query = Query.find_by_sql(
      "select o.id organisation_id, o.name organisation_name,hp.id host_provider_id, hp.name host_provider_name, o.residential_suburb organisation_suburb, o.not_gst_registered, sum(c.amount) sumamount\n"+
      "from claims c\n"+
      "  join organisations o on o.id = c.organisation_id\n"+
      "  left join providers hp on hp.id = c.host_provider_id and hp.seperate_payment = 1\n"+
      "where c.payment_run_id = #{self.id}\n"+
      "and c.invoice_date < '#{Settings::GST_CHANGE.to_s(:db)}'\n"+
      "group by o.id, o.name,o.residential_suburb,hp.id,hp.name,o.not_gst_registered\n"+
      "order by 2,5")
    query
  end
  
  def by_organisation_and_host_provider_post_GST
    query = Query.find_by_sql(
      "select o.id organisation_id, o.name organisation_name,hp.id host_provider_id, hp.name host_provider_name, o.residential_suburb organisation_suburb, o.not_gst_registered, sum(c.amount) sumamount\n"+
      "from claims c\n"+
      "  join organisations o on o.id = c.organisation_id\n"+
      "  left join providers hp on hp.id = c.host_provider_id and hp.seperate_payment = 1\n"+
      "where c.payment_run_id = #{self.id}\n"+
      "and c.invoice_date >= '#{Settings::GST_CHANGE.to_s(:db)}'\n"+
      "group by o.id, o.name,o.residential_suburb,hp.id,hp.name,o.not_gst_registered\n"+
      "order by 2,5")
    query
  end
  
  
  
  
  def by_organisation_and_host_provider
    query = Query.find_by_sql(
      "select o.id organisation_id, o.name organisation_name,hp.id host_provider_id, hp.name host_provider_name, o.residential_suburb organisation_suburb, o.not_gst_registered, sum(c.amount) sumamount\n"+
      "from claims c\n"+
      "  join organisations o on o.id = c.organisation_id\n"+
      "  left join providers hp on hp.id = c.host_provider_id and hp.seperate_payment = 1\n"+
      "where c.payment_run_id = #{self.id}\n"+
      "group by o.id, o.name,o.residential_suburb,hp.id,hp.name,o.not_gst_registered\n"+
      "order by 2,5")
    query
  end
  
  
  # Returns contents of southlink health (slh), Payment file. 
  # The file format is very simple. txt file with the following
  # Doctor Name|DOCTORCODE|PROGRAMME-NAME|GL-CODE|AMOUNT
  # e.g. Horner A|HORNERA|Free Targeted Health Check|6409-74|80.00
  def slh_payment_file
    query = Query.find_by_sql(
      "select o.id organisation_id, o.name organisation_name, o.supplier_code organisation_supplier_code,\n"+
      "       hp.id host_provider_id, hp.name host_provider_name, hp.supplier_code host_provider_supplier_code,\n"+
      "       p.description, f.gl_account_no, sum(c.amount) sumamount\n"+
      "from claims c\n"+
      "  join organisations o on o.id = c.organisation_id\n"+
      "  left join providers hp on hp.id = c.host_provider_id and hp.seperate_payment = 1\n"+
      "  join programmes p on p.id = c.programme_id\n"+
      "  join fee_schedules f on f.id = c.fee_schedule_id\n"+
      "where c.payment_run_id = #{self.id}\n"+
      "group by o.id, o.name, o.supplier_code, hp.id, hp.name, hp.supplier_code,p.description,f.gl_account_no\n"+
      "having sum(c.amount) > 0\n"+
      "order by f.gl_account_no, o.id, hp.id")
    txt = ''
    query.each do |r|
      name=r.organisation_name
      supplier_code=r.organisation_supplier_code
      unless ( r.host_provider_id.blank? )
        name=r.host_provider_name
        supplier_code=r.host_provider_supplier_code
      end
      txt += "#{name}|#{supplier_code}|#{r.description}|#{r.gl_account_no}|#{'%.2f' % r.sumamount.to_f}\r\n"
    end
    txt
  end
  
  # The file format is very simple. csv file with the following
  # o Contact name (GP to be paid) 
  # o Invoice Date in format dd/mm/yyyy (which will always be 1st of the month following service delivery),
  # o Due Date in format dd/mm/yyyy (which will always be 20th of the month following service delivery),
  # o Total Unit Amount (total amount per programme per GP),
  # o GL code (for each programme)
  # Summary :- 
  # Doctor Name,Cut-Off/Invoice-Date,Payment/Due-Date,Amount,GL-Coide
  # Horner A,01/07/2009,20/07/2009,80.00,6409-74
  def welld_payment_file
    query = Query.find_by_sql(
      "select o.id organisation_id, o.name organisation_name,\n"+
      "       hp.id host_provider_id, hp.name host_provider_name,\n"+
      "       f.gl_account_no, sum(c.amount) sumamount\n"+
      "from claims c\n"+
      "  join organisations o on o.id = c.organisation_id\n"+
      "  left join providers hp on hp.id = c.host_provider_id and hp.seperate_payment = 1\n"+
      "  join programmes p on p.id = c.programme_id\n"+
      "  join fee_schedules f on f.id = c.fee_schedule_id\n"+
      "where c.payment_run_id = #{self.id}\n"+
      "group by o.id, o.name, hp.id, hp.name, f.gl_account_no\n"+
      "having sum(c.amount) > 0\n"+
      "order by f.gl_account_no, o.id, hp.id")
    csv = ''
    query.each do |r|
      name=r.organisation_name
      unless ( r.host_provider_id.blank? )
        name=r.host_provider_name
      end
      csv += "#{name},#{self.cut_off_date.strftime('%d/%m/%Y')},#{self.payment_date.strftime('%d/%m/%Y')},#{'%.2f' % r.sumamount.to_f},#{r.gl_account_no}\r\n"
    end
    csv
  end
  
  
  # Returns contents of sage accounting package payment file.  
  # The file format is very simple.csv file with the following
  #
  # Trans Date => self.cut_off_date.strftime('%d/%m/%Y')
  # Account => supplier_code
  # Trans Code => sum_claim_amount > 0 ? 'IN' : 'CN'
  # Reference => 'RUN-#{payment_run.id}-#{organisation_id}-#{max_claim_id}'
  # Description =>fee_schedule_description + '/' + o.name !!! replace "," -> "." 
  # Order Number => BLANK
  # Amount Excl => not_gst_registered
  # Tax Type => 16=GST Purcahses/1=Exempt/2=Zero Rated
  # Amount Incl => sumamount
  # Exchange Rate => 1
  # Foreign Amount Excl => as above
  # Foreign Amount Incl => as above
  # Discount Percent => 0
  # Discount Amount Excl  => 0
  # Discount Tax Type
  # Discount Amount Incl  => 0
  # Foreign Discount Amount Excl => 0
  # Foreign Discount Amount Incl => 0
  # Project Code
  # Split Group => 0
  # Split GL Account  => 0
  # Split Description
  # Split Amount  => 0
  # Foreign Split Amount  => 0
  # Split Project Code  => 0
  # GL Contra Code => gl_cost_centre + f.gl_account_no 
  # Split Tax Type  => 0
  
  def sage_payment_file
    query = Query.find_by_sql(
      "select o.id organisation_id, o.supplier_code organisation_supplier_code, o.name organisation_name,\n"+ 
      "       p.code programme_code, f.description fee_schedule_description,\n"+
      "       co.name cost_organisation_name, co.gl_cost_centre cost_organisation_gl_cost_centre,\n"+ 
      "       f.gl_account_no fee_schedule_gl_account_no, o.not_gst_registered,\n"+
      "       max(c.invoice_date) max_invoice_date, max(c.id) max_claim_id, sum(c.amount) sum_claim_amount\n"+
      "from claims c\n"+
      "  join organisations o on o.id = c.organisation_id\n"+
      "  join organisations co on co.id = c.cost_organisation_id\n"+
      "  join programmes p on p.id = c.programme_id\n"+
      "  join fee_schedules f on f.id = c.fee_schedule_id\n"+
      "where c.payment_run_id = #{self.id}\n"+
      "  and c.invoice_date < '#{Settings::GST_CHANGE.to_s(:db)}'\n"+
      "group by o.id, o.supplier_code,o.name,p.code,f.description,\n"+
      "         co.name, co.gl_cost_centre, f.gl_account_no, o.not_gst_registered\n"+
      "having sum(c.amount) <> 0\n"+
      "UNION\n"+
      "select o.id organisation_id, o.supplier_code organisation_supplier_code, o.name organisation_name,\n"+ 
      "       p.code programme_code, f.description fee_schedule_description,\n"+
      "       co.name cost_organisation_name, co.gl_cost_centre cost_organisation_gl_cost_centre,\n"+ 
      "       f.gl_account_no fee_schedule_gl_account_no, o.not_gst_registered,\n"+
      "       max(c.invoice_date) max_invoice_date, max(c.id) max_claim_id, sum(c.amount) sum_claim_amount\n"+
      "from claims c\n"+
      "  join organisations o on o.id = c.organisation_id\n"+
      "  join organisations co on co.id = c.cost_organisation_id\n"+
      "  join programmes p on p.id = c.programme_id\n"+
      "  join fee_schedules f on f.id = c.fee_schedule_id\n"+
      "where c.payment_run_id = #{self.id}\n"+
      "  and c.invoice_date >= '#{Settings::GST_CHANGE.to_s(:db)}'\n"+
      "group by o.id, o.supplier_code,o.name,p.code,f.description,\n"+
      "         co.name, co.gl_cost_centre, f.gl_account_no, o.not_gst_registered\n"+
      "having sum(c.amount) <> 0\n"+
      "order by 1,2,3,4,5,6,7")    
    #      "and c.invoice_date < '#{Settings::GST_CHANGE.to_s(:db)}'\n"+
    
    csv = 'Trans Date,Account,Trans Code,Reference,'+
          'Description,Order Number,Amount Excl,Tax Type,Amount Incl,'+
          'Exchange Rate,Foreign Amount Excl,Foreign Amount Incl,'+
          'Discount Percent,Discount Amount Excl,Discount Tax Type,'+
          'Discount Amount Incl,Foreign Discount Amount Excl,Foreign Discount Amount Incl,'+
          'Project Code,Split Group,Split GL Account,Split Description,Split Amount,'+
          'Foreign Split Amount,Split Project Code,'+
          'GL Contra Code,Split Tax Type'+"\r\n"
    
    # to_date
    query.each do |r|
      trans_date = r.max_invoice_date.to_date;
      
      account = r.organisation_supplier_code.to_s
      account = "ERROR-NO-SUPPLIER-CODE-#{r.organisation_name.gsub(/,/,'.')}" if ( account.blank? )
      
      amount_incl = r.sum_claim_amount.to_f;
      trans_code = 'IN' # Invoice
      trans_code = 'CN' if amount_incl < 0.00 # Credit
      reference = "RUN-#{self.id}-#{r.organisation_id}-#{r.max_claim_id}"
      description = "#{r.programme_code}-#{r.fee_schedule_description}/#{r.cost_organisation_name}"
      
      amount_excl = 0.00 
      if ( trans_date >= Settings::GST_CHANGE )
        amount_excl = ( "%.2f" % (amount_incl / ( 1 + Settings::GST_POST ))).to_f
      else
        amount_excl = ( "%.2f" % (amount_incl / ( 1 + Settings::GST_PRE ))).to_f
      end
      
      tax_type = '12' # GST on Purchases
      if ( r.not_gst_registered ) 
        amount_excl = amount_incl
        tax_type = '1' # GST Exempt
      end
      
      gl_cost_centre = r.cost_organisation_gl_cost_centre;
      gl_cost_centre = "ERROR-NO-COST-CENTRE-#{r.cost_organisation_name.gsub(/,/,'.')}" if ( gl_cost_centre.blank? )
      
      gl_contra_code = r.fee_schedule_gl_account_no;
      gl_contra_code = "ERROR-NO-GL-ACCOUNT-NO-#{r.fee_schedule_description.gsub(/,/,'.')}" if ( gl_contra_code.blank? )
      
      gl_contra_code = gl_contra_code.sub(/##/,gl_cost_centre) # Merge cost center with GL Code 
      
      
      # 'Trans Date,Account,Trans Code,Reference,'
      csv += "#{trans_date.strftime('%d/%m/%Y')},#{account},#{trans_code},#{reference},"
      
      # 'Description,Order Number,Amount Excl,Tax Type,Amount Incl,'
      csv += "#{description.gsub(/,/,'.')},,#{'%.2f' % amount_excl},#{tax_type},#{'%.2f' % amount_incl},"
      
      # 'Exchange Rate,Foreign Amount Excl,Foreign Amount Incl'
      csv += "1,#{'%.2f' % amount_excl},#{'%.2f' % amount_incl},"
      
      # 'Discount Percent,Discount Amount Excl,Discount Tax Type,'
      csv += "0,0,,"
      
      # 'Discount Amount Incl,Foreign Discount Amount Excl,Foreign Discount Amount Incl,'
      csv += "0,0,0,"
      
      # 'Project Code,Split Group,Split GL Account,Split Description,Split Amount,'
      csv += ",0,0,,0,"
      
      # 'Foreign Split Amount,Split Project Code,'
      csv += "0,0,"
      
      # 'GL Contra Code,Split Tax Type'
      csv += "#{gl_contra_code},0,"
      
      csv += "\r\n" 
    end
    csv      
  end  
  
  
  
  
  # returns summary of payment by provider (who require seperate payment) within an organisation
  # this allows individual payment by provider
  # NOTE: host_provider_id of null, this represents payment to the organisation (not provider)
  # Return host_provider_id, host_provider_name, sumamount
  def by_seperate_payments_by_provider_for_organisation(organisation_id)
    query = Query.find_by_sql(
      "select hp.id host_provider_id, hp.name host_provider_name,  sum(c.amount) sumamount\n"+
      "from claims c\n"+
      " join organisations o on o.id = c.organisation_id\n"+
      " left join providers hp on hp.id = c.host_provider_id and hp.seperate_payment = 1\n"+
      "where c.payment_run_id = #{self.id} and c.organisation_id = #{organisation_id}\n"+
      "group by hp.id, hp.name\n"+
      "order by 2")
    query
  end
  
  # Return the General Ledger Account Breakdown for a payment run pre GST Change
  def by_gl_account_no_pre_GST
    query = Query.find_by_sql(
      "select c.fee_schedule_id, f.gl_account_no,p.description programme_description, f.description,o.not_gst_registered, sum(c.amount) sumamount\n"+
      "from claims c\n"+
      "  left join organisations o on o.id = c.organisation_id\n"+
      "  left join fee_schedules f on f.id = c.fee_schedule_id\n"+
      "  left join programmes p on p.id = c.programme_id\n"+
      "where c.payment_run_id = #{self.id}\n"+
      "and c.invoice_date < '#{Settings::GST_CHANGE.to_s(:db)}'\n"+
      "group by c.fee_schedule_id, f.gl_account_no,p.description, f.description,o.not_gst_registered\n"+
      "order by 2,3,1\n")
    query
  end
  
  def by_gl_account_no_post_GST
    query = Query.find_by_sql(
      "select c.fee_schedule_id, f.gl_account_no,p.description programme_description, f.description,o.not_gst_registered, sum(c.amount) sumamount\n"+
      "from claims c\n"+
      "  left join organisations o on o.id = c.organisation_id\n"+
      "  left join fee_schedules f on f.id = c.fee_schedule_id\n"+
      "  left join programmes p on p.id = c.programme_id\n"+
      "where c.payment_run_id = #{self.id}\n"+
      "and c.invoice_date >= '#{Settings::GST_CHANGE.to_s(:db)}'\n"+
      "group by c.fee_schedule_id, f.gl_account_no,p.description, f.description,o.not_gst_registered\n"+
      "order by 2,3,1\n")
    query
  end
  
  
  # Return the General Ledger Account Breakdown, Grouped by gl_account, By organisation
  def by_gl_account_no_then_organisation
    query = Query.find_by_sql(
      "select c.fee_schedule_id, f.gl_account_no,p.description programme_description, f.description, o.id organisation_id, o.name organisation_name, o.not_gst_registered, sum(c.amount) sumamount\n"+
      "from claims c\n"+
      "  left join fee_schedules f on f.id = c.fee_schedule_id\n"+
      "  left join programmes p on p.id = c.programme_id\n"+
      "  join organisations o on o.id = c.organisation_id\n"+
      "where c.payment_run_id = #{self.id}\n"+
      "group by c.fee_schedule_id, f.gl_account_no,p.description, f.description, o.id, o.name, o.not_gst_registered \n"+
      "order by 2,3,1,6 desc\n" );
    query.in_groups_by(&:fee_schedule_id)
  end
  
  # Return, claims details for the payment run, for just this  organisation
  def claims_for_organisation(organisation_id)
    # NOTE: A transaction may not have a provider !!!
    query = Query.find_by_sql(
      "select c.id claim_id, c.invoice_date, c.invoice_no,
           c.host_provider_id, hp.name host_provider_name,
           c.amount, c.comment, p.family_name, p.given_names, p.nhi_no,g.id programme_id, g.description programme_description,  f.description fee_description\n"+ 
      "from claims c\n"+
      " left join providers hp on hp.id = c.host_provider_id\n"+
      "   join patients p on p.id = c.patient_id\n"+
      "  join programmes g on g.id = c.programme_id\n"+
      "    join fee_schedules f on f.id = c.fee_schedule_id\n"+
      "where c.organisation_id = #{organisation_id} and c.payment_run_id = #{self.id}\n"+
      "order by c.invoice_date, c.id" );
    query
  end
  
  # Return, claims details for the payment run, just for this organisation
  # This returns an array or array grouped by programme_id
  # NOTE: A transaction may not have a provider !!!
  def claims_for_organisation_grouped_by_programme(organisation_id)
    query = Query.find_by_sql(
      "select c.id claim_id, c.invoice_date, c.invoice_no,
           c.host_provider_id, hp.name host_provider_name,
           c.amount, c.comment, p.family_name, p.given_names, p.nhi_no,g.id programme_id, g.description programme_description,  f.description fee_description\n"+ 
      "from claims c\n"+
      " left join providers hp on hp.id = c.host_provider_id\n"+
      "   join patients p on p.id = c.patient_id\n"+
      "  join programmes g on g.id = c.programme_id\n"+
      "    join fee_schedules f on f.id = c.fee_schedule_id\n"+
      "where c.organisation_id = #{organisation_id} and c.payment_run_id = #{self.id}\n"+
      "order by g.id, c.invoice_date, c.id" );
    query.in_groups_by(&:programme_id )
  end
  
  # Returns programme_id, and sumamount for this payment_run
  def programmes_for_organisation(organisation_id)
    # Return organisation_id,organisation_name, organisation_suburb, sumamount
    query = Query.find_by_sql(
      "select g.id programme_id, g.description programme_description,  sum(c.amount) sumamount\n"+
      "from claims c\n"+
      "  join programmes g on g.id = c.programme_id\n"+
      "where c.organisation_id = #{organisation_id} and c.payment_run_id = #{self.id}\n"+
      "group by g.id, g.description\n"+
      "order by g.id, g.description" );
    query
  end 
  
  # Return list of claims paid in this payment run, for this organisation and programme
  # This also unions, claims which have not been paid, in the period (month) prior to cut-off-date
  def claims_for_organisation_programme(organisation_id,programme_id)
    query = Query.find_by_sql(
      "select c.id claim_id, c.invoice_date, c.invoice_no, c.payment_run_id,\n"+
      "       c.claim_status_id, cs.description claim_status_description,\n"+
      "       c.host_provider_id, hp.name host_provider_name,\n"+
      "       c.amount, c.comment, \n"+
      "       p.family_name, p.given_names, p.nhi_no,\n"+
      "       f.description fee_description \n"+
      "from claims c\n"+
      "  join patients p on p.id = c.patient_id\n"+
      "  join fee_schedules f on f.id = c.fee_schedule_id\n"+
      "  join claim_statuses cs on cs.id = c.claim_status_id\n"+
      "  left join providers hp on hp.id = c.host_provider_id\n"+
      "where c.organisation_id = #{organisation_id} and c.payment_run_id = #{self.id} and c.programme_id = #{programme_id}\n"+
    # Dont do this as confusing including held items on report.       
    #      "UNION\n"+
    #      "select c.id claim_id, c.invoice_date, c.invoice_no, c.payment_run_id,\n"+
    #      "       c.claim_status_id, cs.description claim_status_description,\n"+
    #      "       c.host_provider_id, hp.name host_provider_name,\n"+
    #      "       c.amount, c.comment, \n"+
    #      "       p.family_name, p.given_names, p.nhi_no,\n"+
    #      "       f.description fee_description \n"+
    #      "from claims c\n"+
    #      "  join patients p on p.id = c.patient_id\n"+
    #      "  join fee_schedules f on f.id = c.fee_schedule_id\n"+
    #      "  join claim_statuses cs on cs.id = c.claim_status_id\n"+
    #      "  left join providers hp on hp.id = c.host_provider_id\n"+
    #      "where c.organisation_id = #{organisation_id} and c.programme_id = #{programme_id}\n"+
    #      " and c.invoice_date >= #{Query.connection.quote(Query.connection.quoted_date(self.cut_off_date.last_month))}\n"+
    #      " and c.invoice_date < #{Query.connection.quote(Query.connection.quoted_date(self.cut_off_date))}\n"+
    #      " and c.payment_run_id <= 1\n"+
    #      " and c.claim_status_id <> #{ClaimStatus::DELETED}\n"+
      "order by c.invoice_date, c.id");
    query
  end
  
  
  # Return list of programmes and totals for, for this organisation, host provider and programme
  # If host_provider_is is blank, Do it for all providers who do not receive seperate payment schedules !!
  # MS: 2011-07-24 
  # Used in conjunction with :- claims_for_organisation_host_provider_programme
  def programmes_for_organisation_host_provider(organisation_id,host_provider_id)
    filter = "";
    if ( host_provider_id.blank? )
      # all providers who are not paid seperately or no provider specified.
      filter = "and ( hp.seperate_payment is null OR hp.seperate_payment = 0 OR hp.id is null )"
    else
      filter = "and c.host_provider_id = #{host_provider_id}"
    end
    query = Query.find_by_sql(
      "select g.id programme_id, g.description programme_description,  sum(c.amount) sumamount\n"+
      "from claims c\n"+
      "  join programmes g on g.id = c.programme_id\n"+
      "  left join providers hp on hp.id = c.host_provider_id\n"+
      "where c.organisation_id = #{organisation_id} and c.payment_run_id = #{self.id}\n"+
      "#{filter}\r\n"+
      "group by g.id, g.description\n"+
      "order by g.id, g.description" );
    query
  end
  
  
  # Return list of claims paid in this payment run, for this organisation, host provider and programme
  # If host_provider_is is blank, Do it for all providers who do not receive seperate payment schedules !!
  def claims_for_organisation_host_provider_programme(organisation_id,host_provider_id,programme_id,order_by_host_provider=false)
    filter = "";
    if ( host_provider_id.blank? )
      # all providers who are not paid seperately or no provider specified.
      filter = "and ( hp.seperate_payment is null OR hp.seperate_payment = 0 OR hp.id is null )"
    else
      filter = "and c.host_provider_id = #{host_provider_id}"
    end
    # MS: 2011-07-22 Change order by for Dodson M/c - Want detailed by provider grouping, Not just summary $'s
    order_by = 'c.invoice_no, c.invoice_date, c.id'
    order_by = 'c.host_provider_id, c.invoice_no, c.invoice_date, c.id' if ( order_by_host_provider )
    
    # MS: 2011-10-17 - Speed up - only need claim_status_description, where payment_run = 0 (i.e.Not paid) 
    query = Query.find_by_sql(
      "select c.id claim_id, c.invoice_date, c.invoice_no, c.payment_run_id,\n"+
      "       c.claim_status_id, '' claim_status_description,\n"+
      "       c.host_provider_id, hp.name host_provider_name,\n"+
      "       c.amount, c.comment, c.date_service,\n"+
      "       p.family_name, p.given_names, p.nhi_no,\n"+
      "       f.description fee_description \n"+
      "from claims c\n"+
      "  join patients p on p.id = c.patient_id\n"+
      "  join fee_schedules f on f.id = c.fee_schedule_id\n"+
    # "  join claim_statuses cs on cs.id = c.claim_status_id\n"+
      "  left join providers hp on hp.id = c.host_provider_id\n"+
      "where c.organisation_id = #{organisation_id} and c.payment_run_id = #{self.id} and c.programme_id = #{programme_id}\n"+
      "#{filter}\r\n"+
    # Added to include, Rejected Claims
      "UNION\n"+
      "select c.id claim_id, c.invoice_date, c.invoice_no, c.payment_run_id,\n"+
      "       c.claim_status_id, cs.description claim_status_description,\n"+
      "       c.host_provider_id, hp.name host_provider_name,\n"+
      "       c.amount, c.comment, c.date_service,\n"+
      "       p.family_name, p.given_names, p.nhi_no,\n"+
      "       f.description fee_description \n"+
      "from claims c\n"+
      "  join patients p on p.id = c.patient_id\n"+
      "  join fee_schedules f on f.id = c.fee_schedule_id\n"+
      "  join claim_statuses cs on cs.id = c.claim_status_id\n"+
      "  left join providers hp on hp.id = c.host_provider_id\n"+
      "where c.organisation_id = #{organisation_id} and c.payment_run_id = 0 and c.programme_id = #{programme_id}\n"+
      " and c.invoice_date >= #{Query.connection.quote(Query.connection.quoted_date(self.cut_off_date.last_month))}\n"+
      " and c.invoice_date < #{Query.connection.quote(Query.connection.quoted_date(self.cut_off_date))}\n"+
      " and c.claim_status_id = #{ClaimStatus::DECLINED}\n"+
      "#{filter}\r\n"+
      "order by #{order_by}")
    query
  end
  
  
  # Return list of claims for this payment run, where moneys paid to others
  def claims_paid_to_others_for_organisation_programme(cost_organisation_id,programme_id)
    query = Query.find_by_sql(
      "select c.id claim_id, c.invoice_date, c.invoice_no, \n"+
      "       c.amount, c.comment, \n"+
      "       p.family_name, p.given_names, p.nhi_no,\n"+
      "       f.description fee_description,\n"+
      "       o.name organisation_name\n"+
      "from claims c\n"+
      "  join patients p on p.id = c.patient_id\n"+
      "  join fee_schedules f on f.id = c.fee_schedule_id\n"+
      "  join organisations o on o.id = c.organisation_id\n"+
      "where c.cost_organisation_id = #{cost_organisation_id} and c.payment_run_id = #{self.id} and c.programme_id = #{programme_id}\n"+
      "  and c.cost_organisation_id <> c.organisation_id and c.amount <> 0\n"+
      "order by c.invoice_date, c.id");
    query
  end
  
  
end
