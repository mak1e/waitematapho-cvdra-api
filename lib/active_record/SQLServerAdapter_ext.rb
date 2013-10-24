# Enhance ActiveRecord.connection to have a very low level /raw fetch
# this simply returns an array of records
# each row in its one array, with the 1st row containing the column names.
class ActiveRecord::ConnectionAdapters::SQLServerAdapter
        def raw_select(sql, name = nil)
          repair_special_columns(sql)
          result=[]
          execute(sql) do |handle|
            result << handle.column_names.dup
            handle.each do |row|
              result << row.dup
            end
          end
          result
        end
end
