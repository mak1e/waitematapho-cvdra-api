# == Schema Information
#
# Table name: location
#
#  loccode           :string(1)     not null
#  name              :string(35)    not null
#  locresidence      :string(35)    
#  locstreet         :string(30)    
#  locsuburb         :string(20)    
#  loccity           :string(20)    
#  locpostcode       :string(10)    
#  posresiden        :string(35)    
#  posstreet         :string(30)    
#  possuburb         :string(20)    
#  poscity           :string(20)    
#  pospostcode       :string(10)    
#  dayphone          :string(13)    
#  ahphone           :string(13)    
#  faxphone          :string(13)    
#  unlno             :string(10)    
#  gstpercentage     :decimal(10, 2 not null
#  tcpatletter       :string(4096)  
#  tcmemberletter    :string(4096)  
#  tcpatdoccode      :string(8)     
#  tcmemdoccode      :string(8)     
#  loginmessage      :string(4096)  
#  contractno        :integer(252)  
#  payeeno           :integer(252)  
#  rowinsertwhen     :timestamp(252 not null
#  rowinsertstaff    :string(4)     not null
#  rowinsertcomputer :string(15)    not null
#  rowinsertlocation :string(1)     not null
#  roweditwhen       :timestamp(252 not null
#  roweditstaff      :string(4)     not null
#  roweditcomputer   :string(15)    not null
#  roweditlocation   :string(1)     not null
#  rowinactive       :integer(252)  not null
#

class Linktech < ActiveRecord::Base
  set_table_name 'location'

  establish_connection "linktech_#{RAILS_ENV}"
 
 
# Linktech.connection.select_all('select * from location')
# ActiveRecord::Base.configurations
# Linktech.connection.native_database_types
# Linktech.connection.execute_immediate
# a=Linktech.connection.execute('select * from area')
# //result_set=Linktech.connection.raw_connection.execute_immediate('select * from area')
# row=a.fetch (while ! nil)/ each etc ... 
 
# def find_by_sql(sql)
#        connection.select_all(sanitize_sql(sql), "#{name} Load").collect! { |record| instantiate(record) }
# end
#
#def sanitize_sql_array(ary)
#2037:           statement, *values = ary
#2038:           if values.first.is_a?(Hash) and statement =~ /:\w+/
#2039:             replace_named_bind_variables(statement, values.first)
#2040:           elsif statement.include?('?')
#2041:             replace_bind_variables(statement, values)
#2042:           else
#2043:             statement % values.collect { |value| connection.quote_string(value.to_s) }
#2044:           end
#2045:         end
#
#
#
# def Linktech.my_sanitize_sql(condition)
#     sanitize_sql_for_conditions(condition)
# end
# 
# # This is a work around for 
# def Linktech.my_select_all(condition)
#    Linktech.connection.select_all(Linktech.my_sanitize_sql(condition))
# end
 
  # Build SQL to get the payment summary by practice from the LinkTech database.
  def self.cbf_summary_sql(mth,cbf_ident=nil)
    mth=mth.to_date # Make sure a date
     
    # CBF is based on QTR
    qtr=mth.beginning_of_quarter
     
    # FFS is based on 15th of the month
    mth=mth.beginning_of_month + 14
    # puts "qtr=#{qtr.to_s(:db)} mth=#{mth.to_s(:db)} "
     
    sql = 
      "SELECT p.praccode cbf_ident, p.name,\n"+
      "  c.cap_mth,\n"+
      "  f.ded_mth,\n"+
      "  c.under6_mth,\n"+
      "  c.vcla_mth,\n"+
      "  c.cplus_mth,\n"+
      "  c.sia_mth,\n"+
      "  c.hp_mth,\n"+
      "  c.funded_pts,\n"+
      "  c.huhc_pts,\n"+
      "  c.mpi_pts,\n"+
      "  c.q5_pts,\n"+
      "  c.hneeds_pts,\n"+
      "  c.under6_pts,\n"+
      "  c.cplus_eligable,\n"+
      "  c.cplus_residual,\n"+
      "  c.cplus_enrolled,\n"+
      "  c.cplus_residual_hneeds,\n"+
      "  c.cplus_enrolled_hneeds\n"+
      "FROM PRACTICE p\n"+
      " LEFT JOIN Z_FFS_SUMMARY_PRAC f on f.ffsdatestamp = '#{mth.to_s(:db)}'  and f.praccode = p.praccode\n"+
      " LEFT JOIN Z_CBF_SUMMARY_PRAC c on c.ackdatestamp = '#{qtr.to_s(:db)}'  and c.praccode = p.praccode\n"+
      "WHERE ( f.ded_mth is not null OR c.cap_mth is not null)\n"
    sql += "AND p.praccode = '#{cbf_ident}'" unless cbf_ident.blank? 
    # Dont use orderby or Union otherwise get matadata or row error!!!
    sql
  end
 
  # Return the summary by practice from the LinkTech database.
  # NOTE: payment is total MAX payment, not perage as defined in set-up. 
  def self.cbf_summary(mth,cbf_ident=nil)
    sql = self.cbf_summary_sql(mth,cbf_ident);
    ds = Linktech.connection.select_all(sql)
    ds.sort! {|x,y| x["cbf_ident"] <=> y["cbf_ident"] }
    ds
    self.calc_cbf_payment_perage(mth,ds)    
  end

  # Calculate the payment percentages, based on Organisation settings
  # Side effects:- Replaces name (from cbf id) and adds in supplier_code, gl_cost_centre 
  def self.calc_cbf_payment_perage(mth,ds)
    mth=mth.to_date.beginning_of_month
    qtr=mth.beginning_of_quarter
    ds.each do |e|
      org=Organisation.find_by_cbf_ident( e["cbf_ident"] )
      if !org
        org=Organisation.new
        org.name = "CBF:#{e["cbf_ident"]} - #{e["name"]}"
      end
      
      # Replace name
      e["name"] = org.name;
      
      # Add supplier_code, gl_cost_centre 
      e["supplier_code"] = org.cbf_supplier_code;
      e["supplier_code"] = org.supplier_code if org.cbf_supplier_code.blank?; # Use supplier_code if cbf not supplied.
      e["gl_cost_centre"] = org.gl_cost_centre;
      
      # Calc payments 
      e["cplus_pay"] = 0.00; 
      e["under6_pay"] = 0.00;
      e["vcla_pay"] = 0.00; 
      e["sia_pay"] = 0.00;
      e["hp_pay"] = 0.00;
      
      # Blank out under6/vcla if practice not enrolled forit. 
      e["under6_mth"] = "" unless org.cbf_under6_perage.to_i > 0 
      e["vcla_mth"] = "" unless org.cbf_vcla_perage.to_i > 0
      
      # Calc practice payment
      e["cplus_pay"] = ( e["cplus_mth"].to_f * org.cbf_cplus_perage / 100.00 ).round(2) if org.cbf_cplus_perage.to_i > 0 
      e["under6_pay"] = ( e["under6_mth"].to_f * org.cbf_under6_perage / 100.00 ).round(2) if org.cbf_under6_perage.to_i > 0 
      e["vcla_pay"] = ( e["vcla_mth"].to_f * org.cbf_vcla_perage / 100.00 ).round(2) if org.cbf_vcla_perage.to_i > 0
      e["sia_pay"] = ( e["sia_mth"].to_f * org.cbf_sia_perage / 100.00 ).round(2) if org.cbf_sia_perage.to_i > 0
      e["hp_pay"] = ( e["hp_mth"].to_f * org.cbf_hp_perage / 100.00 ).round(2) if org.cbf_hp_perage.to_i > 0

      if ( org.cbf_under6_qtrly_payment.to_i > 0 )
        # Pay under6 qtrly.
        e["under6_pay"] = (e["under6_pay"].to_f * 3).round(2); # multiply figures by 3 (3 months in a qtr)  
        e["under6_pay"] = 0.00 if ( mth != qtr ); # Not start of QTR, amount is 0 
      end
      
      if ( org.cbf_vcla_qtrly_payment.to_i > 0 )
        # Pay vcla qtrly.
        e["vcla_pay"] = (e["vcla_pay"].to_f * 3).round(2); # multiply figures by 3 (3 months in a qtr)  
        e["vcla_pay"] = 0.00 if ( mth != qtr ); # Not start of QTR, amount is 0 
      end


    end
    ds
  end


  # Download the CSV summary, 
  def self.cbf_summary_csv(mth,cbf_ident=nil)
    ds = self.cbf_summary(mth,cbf_ident);
    # Dont start a CSV with ID, as excell thinks its a SLKY file !!!!
    csv = "CBF-ID,Name - Mth #{mth.strftime("%Y-%m")},CBF,Deductions,CBF-Payment,C-Plus,Under-6,VCLA,SIA,HP,"+
          "# Patients,# HUHC,# High Needs,# C-Plus Enrolled,# C-Plus Eligable,# C-Plus Residual,"+
          "$ C-Plus Subsidy,$ SIA Subsidy,$ HP Subsidy,$ Under 6 Subsidy, $ VCLA Subsidy\r\n"
    ds.each do |r|
      csv += "#{r['cbf_ident']},#{r['name']},#{r['cap_mth']},#{r['ded_mth']},#{r['cap_mth'].to_f-r['ded_mth'].to_f},#{r['cplus_pay']},#{r['under6_pay']},#{r['vcla_pay']},#{r['sia_pay']},#{r['hp_pay']},"+
           "#{r['funded_pts']},#{r['huhc_pts']},#{r['hneeds_pts']},#{r['cplus_enrolled']},#{r['cplus_eligable']},#{r['cplus_residual']},"+
           "#{r['cplus_mth']},#{r['sia_mth']},#{r['hp_mth']},#{r['under6_mth']},#{r['vcla_mth']}\r\n"
    end
    csv
  end

  # Generate SAGE payment file for practcies.Based on cbf_summary_sql + calc_cbf_payment_perage
  # 
  # The file format is very simple.csv file with the following
  #
  # Trans Date => 30th of last month, Since payment is for this month.
  # Account => supplier_code
  # Trans Code => sum_claim_amount > 0 ? 'IN' : 'CN'
  # Reference => 'CBF-YYYYMM-#{supplier code}}'
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
  def self.cbf_sage_payment_file(mth,cbf_ident=nil)
    ds = self.cbf_summary(mth,cbf_ident);
    
    invoice_date=mth.to_date # Make sure a date
    # invoice_date=invoice_date.beginning_of_month + 14; # Invoice are on the 15th of the month.
    # MS: 2011-10-17 # Invoice are now for the end of the previous month (So gets paid this month)
    invoice_date=invoice_date.beginning_of_month.yesterday;  
      
    csv = 'Trans Date,Account,Trans Code,Reference,'+
          'Description,Order Number,Amount Excl,Tax Type,Amount Incl,'+
          'Exchange Rate,Foreign Amount Excl,Foreign Amount Incl,'+
          'Discount Percent,Discount Amount Excl,Discount Tax Type,'+
          'Discount Amount Incl,Foreign Discount Amount Excl,Foreign Discount Amount Incl,'+
          'Project Code,Split Group,Split GL Account,Split Description,Split Amount,'+
          'Foreign Split Amount,Split Project Code,'+
          'GL Contra Code,Split Tax Type'+"\r\n"
          
    # to_date
    ds.each do |r|
      csv += self.cbf_sage_payment_line(invoice_date,r,'cap_mth',   'CAP',   'IN', 'First Contact Services',     Settings.instance.cbf_cap_gl_account_no);
      csv += self.cbf_sage_payment_line(invoice_date,r,'ded_mth',   'DED',   'CN', 'GMS - Casual',               Settings.instance.cbf_ded_gl_account_no);
      csv += self.cbf_sage_payment_line(invoice_date,r,'cplus_pay', 'CPLUS', 'IN', 'Care Plus',                  Settings.instance.cbf_cplus_gl_account_no);
      csv += self.cbf_sage_payment_line(invoice_date,r,'under6_pay','UNDER6','IN', 'Under Sixes',                Settings.instance.cbf_under6_gl_account_no);
      csv += self.cbf_sage_payment_line(invoice_date,r,'vcla_pay',  'VCLA',  'IN', 'Very Low Cost Access',       Settings.instance.cbf_vcla_gl_account_no);
      csv += self.cbf_sage_payment_line(invoice_date,r,'sia_pay',   'SIA',   'IN', 'Services to Improve Access', Settings.instance.cbf_sia_gl_account_no);
      csv += self.cbf_sage_payment_line(invoice_date,r,'hp_pay',    'HP',    'IN', 'Health Promotion',           Settings.instance.cbf_hp_gl_account_no);
    end      
    csv      
  end  
  
  
  # Return Line item for the sage payment file
  def self.cbf_sage_payment_line(invoice_date,item,column_name,ref_code,trans_code,description,gl_account_no)
    csv = '';
    amount_incl = item[column_name].to_f;
    
    if (amount_incl > 0.01)
      account = item['supplier_code'].to_s
      account = "ERROR-NO-SUPPLIER-CODE-#{item['name'].gsub(/,/,'.')}" if ( account.blank? )
      
      reference = "CBF-#{invoice_date.strftime('%Y-%m')}-#{ref_code}-#{item['cbf_ident']}" # Keep reference no the same, as hopefully places on same invoice 
      description = "#{description}/#{item['name']}"
      
      amount_excl = 0.00 
      if ( invoice_date >= Settings::GST_CHANGE )
        amount_excl = ( "%.2f" % (amount_incl / ( 1 + Settings::GST_POST ))).to_f
      else
        amount_excl = ( "%.2f" % (amount_incl / ( 1 + Settings::GST_PRE ))).to_f
      end
        
      tax_type = '12' # GST on Purchases
      
      gl_cost_centre = item['gl_cost_centre'];
      gl_cost_centre = "ERROR-NO-COST-CENTRE-#{item['name'].gsub(/,/,'.')}" if ( gl_cost_centre.blank? )
      
      gl_contra_code = gl_account_no;
      gl_contra_code = "ERROR-NO-GL-ACCOUNT-NO-#{item['name'].gsub(/,/,'.')}" if ( gl_contra_code.blank? )
      
      gl_contra_code = gl_contra_code.sub(/##/,gl_cost_centre) # Merge cost center with GL Code 
      
     
      # 'Trans Date,Account,Trans Code,Reference,'
      csv = "#{invoice_date.strftime('%d/%m/%Y')},#{account},#{trans_code},#{reference},"
      
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

  def self.cbf_summary_by_agegroup(mth,cbf_ident)
    # CBF is based on QTR
    qtr=mth.beginning_of_quarter
    # FFS is based on 15th of the month
    mth=mth.beginning_of_month + 14
    
    # Get the capitation payments
    sql = 
      "select p.praccode cbf_ident,\n"+
      "  c.agegroup,\n"+
      "  sum(c.funded_pts) funded_pts,\n"+
      "  sum(c.huhc_pts) huhc_pts,\n"+
      "  sum(c.hneeds_pts) hneeds_pts,\n"+
      "  sum(c.cplus_enrolled) cplus_pts,\n"+
      "  sum(c.cap_mth) cap_mth\n"+
      "FROM PRACTICE p\n"+ 
      " LEFT JOIN Z_CBF_SUMMARY c on c.ackdatestamp = '#{qtr.to_s(:db)}'  and c.praccode = p.praccode\n"+
      "WHERE p.praccode = '#{cbf_ident}'\n"+
      "GROUP BY p.praccode,c.agegroup \n"
      "ORDER BY 1,2\n"
    ds = Linktech.connection.select_all(sql)
    ds
  end
  
  
  # Return the summary by provider, for a practice from the LinkTech database.
  def self.cbf_breakdown_by_registration_no(mth,cbf_ident)
    
    # CBF is based on QTR
    qtr=mth.beginning_of_quarter
    # FFS is based on 15th of the month
    mth=mth.beginning_of_month + 14
    
    # Get the capitation payments
    sql = 
      "SELECT p.praccode cbf_ident, c.regno registration_no, sum(c.funded_pts) funded_pts, sum(c.cap_mth) cap_mth\n"+ 
      "FROM PRACTICE p\n"+ 
      " LEFT JOIN Z_CBF_SUMMARY c on c.ackdatestamp = '#{qtr.to_s(:db)}'  and c.praccode = p.praccode\n"+
      "WHERE p.praccode = '#{cbf_ident}'\n"+
      "GROUP BY p.praccode, c.regno \n"+
      "ORDER BY 1,4 desc\n"
    ds = Linktech.connection.select_all(sql)
    
    # Get the fee for service deductions
    sql = 
      "SELECT p.praccode cbf_ident, f.regno registration_no, f.ded_mth\n"+
      "FROM PRACTICE p\n"+ 
      " LEFT JOIN Z_FFS_SUMMARY f on f.ffsdatestamp = '#{mth.to_s(:db)}'  and f.praccode = p.praccode\n"+
      "WHERE p.praccode = '#{cbf_ident}'\n"+
      "ORDER BY 1,2\n"
    ffs = Linktech.connection.select_all(sql)
    
    # Merge the two.
    ffs.each do |ded|
       # find the row. 
       r=ds.select { |e| e["registration_no"] == ded["registration_no"] }
       if ( r.length > 0 ) then
          # Add/merge deductions to the dataset ds hash
          r[0].update(ded)
       else
          # registration no not found, Add to end
          ds.push(ded)
       end
    end
    # ds.sort! {|x,y| -(x["funded_pts"].to_i <=> y["funded_pts"].to_i) }    
    
    return ds
    
  end

  def self.cbf_extras_by_registration_no(mth,cbf_ident)
    
    # CBF is based on QTR
    qtr=mth.beginning_of_quarter
    # FFS is based on 15th of the month
    mth=mth.beginning_of_month + 14
    
    # Get the capitation payments
    sql = 
      "SELECT p.praccode cbf_ident, c.regno registration_no, \n"+
      "  sum(c.under6_mth) under6_mth,\n"+
      "  sum(c.vcla_mth) vcla_mth,\n"+
      "  sum(c.cplus_mth) cplus_mth\n"+
      "FROM PRACTICE p\n"+ 
      " LEFT JOIN Z_CBF_SUMMARY c on c.ackdatestamp = '#{qtr.to_s(:db)}'  and c.praccode = p.praccode\n"+
      "WHERE p.praccode = '#{cbf_ident}'\n"+
      "GROUP BY p.praccode, p.name, c.regno\n"+
      "ORDER BY 1,3 desc,4 desc,5 desc\n"
    ds = Linktech.connection.select_all(sql)
    ds = self.calc_cbf_payment_perage(mth,ds)    
    return ds
  end
  
  
  
  # NHI/Name ... Count of deductions for a month/practice
  def self.ffs_deduction_details(mth,cbf_ident)
    # FFS is based on 15th of the month
    mth=mth.beginning_of_month + 14
    sql = 
      "select f.praccode cbf_ident, f.nhino nhi_no, a.preformattedintern name, f.claimcode gms_claim, m.regno registration_no,\n"+
      " f.dateofvisit, f.ffsamtdeducted\n"+
      "from ffsdedds f\n"+
      " left join anybody a on a.anybodyid = f.anybodyid\n"+
      "  left join member m on m.memcode = a.memcode\n"+ 
      "where f.praccode = '#{cbf_ident}' and f.ffsdatestamp = '#{mth.to_s(:db)}'\n"+
      "and f.ffsamtpaid > 0\n"+
#      "group by f.praccode,f.nhino, a.preformattedintern, f.claimcode, m.regno\n"+
      "order by 2, 6\n"
    # ds is Array, with hash for each row. 
    ds = Linktech.connection.select_all(sql)
    ds
  end
  

  # Count of deductions by Age/Group and Day of week for a month/practice
  # Returns Array for each age group.
  def self.ffs_deductions_by_age_group_dow(mth,cbf_ident)
    # FFS is based on 15th of the month
    mth=mth.to_date.beginning_of_month + 14
    sql = 
      "select Z_PHOCAPRATES.agegroup_gms age_group, Z_DAYOFWEEK.DOW day_of_week,count(f.anybodyid) count_deductions\n"+
      "from ffsdedds f\n"+
      " left join anybody a on a.anybodyid = f.anybodyid\n"+
      " left join Z_DAYOFWEEK( f.dateofvisit ) on 1=1\n"+
      " left join Z_PHOCAPRATES( f.ffsdatestamp, a.dob, a.gencode, null,null,null,null,null,null ) on 1=1\n"+
      "where f.praccode = '#{cbf_ident}' and f.ffsdatestamp = '#{mth.to_s(:db)}'\n"+
      "group by Z_PHOCAPRATES.agegroup_gms, Z_DAYOFWEEK.DOW\n"+
      "order by 1,2\n"
    # ds is Array, with hash for each row.
 
    ds = Linktech.connection.select_all(sql)
    ds
    # Flattern, to spread sheet (array) base on dow/deductions e.g. 
    # Array [ "Age/Group", "Day-0","Day-1","Day-2" etc... }
    ss=ds.inject([]) { |i,e| i << [e["age_group"],0,0,0,0,0,0,0] }
    ss.uniq!
    ss.unshift(["Age/Group","Sun","Mon","Tue","Wed","Thu","Fri","Sat"])
    ds.each do |r|
      dow=r["day_of_week"]
      age_group=r["age_group"]
      a=ss.select { |e| age_group == e[0] }
      # should always find a row !!!
      a[0][dow+1] =r["count_deductions"] 
    end
    ss
  end
  
  # Count of deductions by Age/Group and Day of week for a month/practice
  # Returns Array for each age group.
  def self.ffs_deductions_by_gms_claim(mth,cbf_ident)
    # FFS is based on 15th of the month
    mth=mth.to_date.beginning_of_month + 14
    sql = 
      "select f.claimcode gms_claim, count(f.anybodyid) count_deductions, sum( f.ffsamtdeducted ) total_deductions \n"+
      "from ffsdedds f\n"+
      " left join anybody a on a.anybodyid = f.anybodyid\n"+
      "where f.praccode = '#{cbf_ident}' and f.ffsdatestamp = '#{mth.to_s(:db)}'\n"+
      "group by f.claimcode\n"+
      "order by 2 desc\n"
    # ds is Array, with hash for each row.
 
    ds = Linktech.connection.select_all(sql)
    ds
  end
  
 
end
