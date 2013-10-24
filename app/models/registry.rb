# == Schema Information
#
# Table name: registries
#
#  id      :integer       not null, primary key
#  section :string(18)    not null
#  ident   :string(18)    not null
#  value   :text          
#  user_id :integer       
#

class Registry < ActiveRecord::Base
  
  ASR_SECTION = 'asr'
  ASR_STATUS_IDENT = 'status'
  
  
  def self.read_string(section,ident,default_string='',user_id=nil)
    # Read string
    reg=self.find_by_section_and_ident_and_user_id(section,ident,user_id);
    if reg
      reg.value
    else
      default_string
    end
  end
  
  def self.read(section,ident,default_object=nil,user_id=nil)
    default_base64=Base64.encode64(Marshal.dump(default_object))
    begin
      Marshal.load( Base64.decode64(self.read_string( section,ident,default_base64,user_id)))
    rescue # if get an exception return the default object 
      default_object 
    end
  end    

  def self.write_string(section,ident,a_string,user_id=nil)
    # Read string
    reg=self.find_by_section_and_ident_and_user_id(section,ident,user_id);
    unless reg
      reg=self.new
      reg.section = section
      reg.ident = ident
      reg.user_id = user_id
    end
    reg.value = (a_string)
    reg.save!
  end
  
  def self.write(section,ident,a_object,user_id=nil)
   self.write_string( section,ident,Base64.encode64(Marshal.dump(a_object)),user_id)
  end    

end
