class AddPatientNo1 < ActiveRecord::Migration
  def self.up
    # Add patient with id of 1 this is the PHO itself
    # used when need to lodge invoices, with no patient
    p=Patient.find :first, :conditions => { :id => 1 }
    p.destroy if p
    Patient.create_with_id 1, :family_name => 'PHO'
  end

  def self.down
  end
end
