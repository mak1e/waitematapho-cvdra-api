# == Schema Information
#
# Table name: dhbs
#
#  id         :string(3)     not null, primary key
#  name       :string(18)    not null
#  position   :integer       not null
#  created_at :datetime      
#  updated_at :datetime      
#

class Dhb < ActiveRecord::Base
  def caption
    # Return string sutable for a heading or link to
    if ( self.id.blank? )
      return "New Dhb"
    end
    self.name
  end
end
