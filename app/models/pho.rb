# == Schema Information
#
# Table name: phos
#
#  id              :integer       not null, primary key
#  name            :string(40)    not null
#  dhb_id          :string(3)     not null
#  est_no_patients :integer       
#  deleted         :boolean       not null
#  created_at      :datetime      
#  updated_at      :datetime      
#

class Pho < ActiveRecord::Base
  attr_protected :id
  
  belongs_to :dhb

  validates_length_of :name, :within => 4..40, :allow_nil => false
  validates_numericality_of :est_no_patients, :allow_nil => true

  def caption
    # Return heading for a patient
    if ( self.id.blank? )
      return "New Pho"
    end
    "#{self.name}"
  end 
  
end
