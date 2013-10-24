class Report::BaseController < ApplicationController
  layout 'report'
  
  # Create fake ActiveRecord class to pass information to/from the view
  class Criteria < ActiveRecord::BaseWithoutTable
     column 'start_date', :date
     column 'end_date', :date
     column 'programme_id', :integer
     column 'fee_schedule_id', :integer
     column 'organisation_id', :integer
     column 'high_needs', :string, :limit => 1 # h=high,n=not

     column 'max_claims', :integer
     column 'seperate_each_organisation', :boolean 
     column 'care_plus_only', :boolean 
     column 'pho_id', :string, :limit => 8
     
     belongs_to :programme
     belongs_to :organisation
     belongs_to :fee_schedule
     
     def save_to_session(session)
       session[:criteria] ||= {}
       Criteria.columns.each do |c|
         session[:criteria][c.name.to_sym] = self.read_attribute(c.name)
       end
       nil
     end
     
     def restore_from_session(session)
       if session[:criteria] 
         Criteria.columns.each do |c|
           self.write_attribute(c.name,session[:criteria][c.name.to_sym])
         end
       end
       nil
     end

     
  end
  
  def transpose_ss(ss)
    ss[0].zip *ss[1..-1]
  end

  # == merge_rv_to_nv
  # Convert/Merge ActiveRecord containing row  column name and value column name, 
  # into array of name/value pairs, (Array of Array[2])
  # Used to take a "select row_cname,count(*)" and place into a ss
  def merge_rv_nv( active_record, row_cname, value_cname, existing_ss = nil )
    ss = existing_ss || Array.new
    for ar in active_record do 
      rval=ar.send(row_cname).to_s
      count=ar.send(value_cname).to_i
      
      # find the row, sorted
      r=0
      while ( r < ss.length ) && ( rval > ss[r][0] )
         r += 1
      end
      
      if ( r < ss.length ) && ( rval == ss[r][0] ) 
         # Already exists, Add to count 
         ss[r][1] += count
      else
         # Insert before r
         ss.insert(r,[rval,count])
      end
    end
    ss
  end
  
  # == merge_hv_to_nv
  # Convert/Merge ActiveRecord containing row heading and value column name, 
  # into array of name/value pairs, (Array of Array[2])
  def merge_hv_nv( active_record, row_heading, value_cname, existing_ss = nil )
    ss = existing_ss || Array.new
    # find the row, sorted
    r=0
    while ( r < ss.length ) && ( row_heading > ss[r][0] )
       r += 1
    end
    
    if ( r < ss.length ) && ( row_heading == ss[r][0] ) 
       # Already exists
    else
       # Insert before r
       ss.insert(r,[row_heading,0])
    end
    
    for ar in active_record do 
      count=ar.send(value_cname).to_i
      ss[r][1] += count
    end
    ss
  end  
  
  # == merge_rhv_ss
  # Convert/Merge ActiveRecord containing row column name, explicit column header and value column name, 
  # into a spreadsheet, (Array of Array[n])
  # The 1st row and 1st column of the returned array contains the headings
  # Used to take a "select row_cname,count(*)" and place into a specific column of a ss
  def merge_rhv_ss( active_record, row_cname, col_header, value_cname, existing_ss = nil )
    ss = existing_ss || Array.new(1,[''])
    # Ist find the column. 
    col_header='Not Stated' if ( col_header == '' )
    # find the column, Note 1st col is reserved. for row headings
    clen=ss[0].length
    c=1
    while ( c < clen ) && ( col_header != ss[0][c] ) #  dont't sort
       c += 1
    end

    # Add in the column       
    if ( c < clen ) && ( col_header == ss[0][c] ) 
      # Column already exists. Do nothing
    else
      # Insert into the Header
      ss[0].insert(c,col_header)
      clen=ss[0].length
      
      # Insert column before c with value of 0 for all existing rows. 
      r=1
      while (r<ss.length)
        ss[r].insert(c,0)
        r += 1
      end
    end
    
    for r in active_record do 
      rval=r.send(row_cname).to_s
      count=r.send(value_cname).to_i
      rval='Not Stated' if ( rval == '' )
          
      # Now Find the row. Note 1st row is reserved. for column header
      r=1
      while ( r < ss.length ) && ( rval != ss[r][0] ) # dont sort. 
         r += 1
      end
      
      # Add to the value 
      if ( r < ss.length ) && ( rval == ss[r][0] ) 
        # Already exists, Add to count at row r, column c
      else
        # Insert before r, Array of zero's
        ss.insert(r,Array.new(clen,0))
        ss[r][0] = rval # Assign the description 
      end
      ss[r][c] += count
    end
    ss # finally return the spread sheet
  end   
  
  # == merge_rcv_ss
  # Convert/Merge ActiveRecord containing row column name, column column name and value column name, 
  # returns (Array[n] of Array[n]) (i.e Matrix or spreadsheet)
  # Used to take a "select row_cname,col_cname,count(*) and place into a ss
  def merge_rcv_ss( active_record, row_cname, col_cname, value_cname, existing_ss = nil )
    ss = existing_ss || Array.new(1,[''])
    for r in active_record do 
      rval=r.send(row_cname).to_s
      col_header=r.send(col_cname).to_s
      count=r.send(value_cname).to_i
      
      rval='Not Stated' if ( rval == '' )
      col_header='Not Stated' if ( col_header == '' )
          

      # find the column, Note 1st col is reserved. for row headings
      clen=ss[0].length
      c=1
      while ( c < clen ) && ( col_header != ss[0][c] ) #  dont't sort
         c += 1
      end
#      while ( c < clen ) && ( cval > ss[0][c] )  # Sort by col. 
#         c += 1
#      end

      # Add in the column       
      if ( c < clen ) && ( col_header == ss[0][c] ) 
        # Column already exists. Do nothing
      else
        # Insert into the Header
        ss[0].insert(c,col_header)
        clen=ss[0].length
        
        # Insert column before c with value of 0 for all existing rows. 
        r=1
        while (r<ss.length)
          ss[r].insert(c,0)
          r += 1
        end
      end

      # Now Find the row. Note 1st row is reserved. for column header
      r=1
      while ( r < ss.length ) && ( rval != ss[r][0] ) # dont sort. 
         r += 1
      end
      
      
      # Add to the value 
      if ( r < ss.length ) && ( rval == ss[r][0] ) 
        # Already exists, Add to count at row r, column c
      else
        # Insert before r, Array of zero's
        ss.insert(r,Array.new(clen,0))
        ss[r][0] = rval # Assign the description 
      end
      ss[r][c] += count
    end
    ss # finally return the spread sheet
  end  
  

end
