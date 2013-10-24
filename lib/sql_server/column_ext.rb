# Patch SqlServerColumn as may need to change column type from datetime to a date, as time cannot be -ve (< 1970) !!!
class ActiveRecord::ConnectionAdapters::SQLServerColumn
  def type=(val)
    @type=val
  end
end 
