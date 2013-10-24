# == Schema Information
#
# Table name: care_plus_criterias
#
#  id          :integer       not null, primary key
#  description :string(28)    not null
#  position    :integer       default(0), not null
#

class CarePlusCriteria < ActiveRecord::Base
    VALID_IDS = [2,3,4,5,6]
end
