# == Schema Information
#
# Table name: ethnicities
#
#  id                  :integer       not null, primary key
#  description         :string(35)    not null
#  level1_ethnicity_id :integer       not null
#  created_at          :datetime      
#  updated_at          :datetime      
#  ethnicity_diab      :string(35)    
#  order_by_diab       :integer       
#  ethnicity_cvdr      :string(35)    
#  order_by_cvdr       :integer       
#  ethnicity_level1    :string(18)    
#  order_by_level1     :integer       
#  ethnicity_mpi       :string(18)    
#  order_by_mpi        :integer       
#

class Ethnicity < ActiveRecord::Base
  belongs_to :level1_ethnicity
  VALID_IDS = [ 10,11,12,21,30,31,32,33,34,35,36,37,40,41,42,43,44,51,52,53,54 ]
  OTHER = 54

  
 
end
