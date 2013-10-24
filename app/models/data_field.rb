# == Schema Information
#
# Table name: data_fields
#
#  id          :integer       not null, primary key
#  column_name :string(50)    not null
#  label       :string(50)    not null
#  data_type   :string(8)     not null
#  limit       :integer       
#  choices     :string(200)   
#

class DataField < ActiveRecord::Base
  DATATYPE_CHOICE_HTML = 'html' # render partial html (as _name_of_column)
  DATATYPE_CHOICES = ['string', 'integer', 'decimal', 'date', 'boolean', DATATYPE_CHOICE_HTML ] 
    
  
  validates_length_of :column_name, :maximum => 50, :allow_nil => false
  validates_length_of :label, :maximum => 50, :allow_nil => false
  validates_length_of :data_type, :maximum => 8, :allow_nil => false
  validates_numericality_of :limit, :allow_nil => true
  validates_length_of :choices, :maximum => 200, :allow_nil => true
  
   # populate the datafields table, from the claims_data columns
   # also remove any that are no longer present in claims_data.
   def self.populate_table
     claim_data_cols=ClaimsData.columns;
     # Delete if column dropped from table
     DataField.find(:all,:conditions => ['data_type <> ?',DATATYPE_CHOICE_HTML]).each do |df|
       cdc=claim_data_cols.find { |c| c.name == df.column_name }
       df.destroy if ( cdc  == nil )
     end
     # Add if column added to table
     claim_data_cols.each do |col|
        if ( col.name != 'id' )
          data_field=self.find_by_column_name(col.name);
          if (!data_field)
             data_field=self.new
             data_field.column_name = col.name
             data_field.label = col.name.titlecase.sub(/[^ ]* /,'')
             data_field.data_type = col.type.to_s
             data_field.data_type = 'date' if data_field.data_type == 'datetime'
             data_field.limit = col.limit if data_field.data_type == 'string'
             data_field.save!
         end
         # Check to see if field sizes changed
         if data_field.data_type == 'string'
           if data_field.limit != col.limit
             data_field.limit = col.limit
             data_field.save!
           end
           
         end
         
       end
     end
     nil
 end
 
  # Return heading for a patient. i.e Name + NHI
  def caption
    "#{self.label} <#{self.column_name}>"
  end   
  
  def self.choices_for_select()
    DataField.find(:all,:select=>"column_name, label",
       :order=>"label").map do |m| 
         [m.label, m.column_name ]
    end
  end     
   
end
