# == Schema Information
#
# Table name: provider_types
#
#  id          :integer       not null, primary key
#  description :string(18)    not null
#  position    :integer       default(0), not null
#

class ProviderType < ActiveRecord::Base
   DOCTOR=1
   NURSE=2
end
