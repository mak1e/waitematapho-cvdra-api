# == Schema Information
#
# Table name: programme_elements
#
#  id                    :integer       not null, primary key
#  programme_id          :integer       not null
#  position              :integer       default(0), not null
#  column_name           :string(50)    
#  report_by             :string(36)    
#  report_by_transpose   :boolean       
#  report_by_2           :string(36)    
#  report_by_transpose_2 :boolean       
#

class ProgrammeElement < ActiveRecord::Base
  attr_protected :id
  
  validates_length_of :column_name, :within => 3..50, :allow_nil => false
  validates_presence_of :programme_id
  
  belongs_to :programme
  
  # Columns you can report by, as Description+column_name
  REPORT_BY_CHOICES = [
    ['Count','count(claims.id)'],
    ['Patient Count','count(distinct claims.patient_id)'],
    ['Service','fee_schedules.description'],
    ['Organisation','organisations.name'],
    ['Age-Band (GMS)','dbo.agerange_gms'], # Special processing, dbo.agerange_gms(patients.date_of_birth,claims.date_service)
    ['Age-Band (IMM)','dbo.agerange_imm'], # Special processing, see above
    ['Ethnicity (Maori/Pacific-I)','ethnicities.ethnicity_mpi'],
    ['Ethnicity (Level-1)','ethnicities.ethnicity_level1'],
    ['Gender','genders.description'],
    ['Qunitile','patients.quintile'],
#    ['Sum','sum(*)'], # Special processing, MS: 2012-02 Removed included kms in std reports. 
    ['Diabetes','claims_data.diab_type_of_diabetes'],
    ['Alcohol Consumption','claims_data.alcs_alcohol_consumption']
    ]



  def data_field
    @data_field ||= DataField.find_by_column_name(self.column_name)
    if ( @data_field == nil )
      @data_field = DataField.new({:column_name => self.column_name, :label => "#{self.column_name} not found!", :data_type => 'string', :limit => 18 })
    end
    @data_field
  end
  
  def caption
    # Return string sutable for a heading or link to
    if ( self.id.blank? )
      return "New Element"
    end
    "#{self.column_name}"
  end    
  
  # Populate elements for a specified programme
  # Takes aata as an array of hashes [ { :position => 0,  :column_name => 'name-of-column'} ]
  def self.populate(programme_id,data)
      ProgrammeElement.delete_all( { :programme_id => programme_id })
      data.each do |elem|
        e=ProgrammeElement.new(elem)
        e.programme_id = programme_id
        e.save!
      end
  end
  
  def self.report_by_choices_for_select()
    REPORT_BY_CHOICES     
  end       
    
  def self.report_by_description(column_name)
    f=REPORT_BY_CHOICES.find { |e| e[1] == column_name }
    retval="Unknown column #{column_name}" 
    retval=f[0] unless f.blank? 
    retval
  end
  
 
end
