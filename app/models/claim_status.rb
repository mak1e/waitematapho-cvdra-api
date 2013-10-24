# == Schema Information
#
# Table name: claim_statuses
#
#  id          :integer       not null, primary key
#  description :string(18)    not null
#  html        :string(48)    not null
#  created_at  :datetime      
#  updated_at  :datetime      
#

class ClaimStatus < ActiveRecord::Base
  HELD = 2
  PENDING = 3
  ACCEPTED = 5
  BORDERLINE = 6
  DELETED = 8
  DECLINED = 9
  
  def caption
    self.description
  end
end
