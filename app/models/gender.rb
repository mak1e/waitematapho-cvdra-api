# == Schema Information
#
# Table name: genders
#
#  id          :string(1)     not null, primary key
#  description :string(13)    not null
#  created_at  :datetime      
#  updated_at  :datetime      
#

class Gender < ActiveRecord::Base
end
