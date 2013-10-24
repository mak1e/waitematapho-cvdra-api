class Array
  def in_groups_by
    # Group elements into individual array's by the result of a block
    # Similar to the in_groups_of function.
    # NOTE: assumes array is already ordered/sorted by group !!
    # Similar in function to the group_by, but group_by is a hash and a hash have no order. 
    curr=nil.class # Something that wont be 1st in the array
    result=[]
    each do |element|
       group=yield(element) # Get grouping value
       result << [] if curr != group # if not same, start a new array
       curr = group
       result[-1] << element
    end
    result
  end
end

