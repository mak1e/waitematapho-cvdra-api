# Enhance ActiveRecord to have a edit_mode attribute
class ActiveRecord::Base
  alias save_base save
  
  def edit_mode?
    self.new_record? || self.errors.size > 0 || @edit_mode
  end

  def edit_mode=(val)
    @edit_mode=val
  end 
  
  def self.create_with_id(id,*args)
    r=self.new(*args)
    r.id = id;
    r.save;
    r;
  end    
  
  def self.choices_for_select
    descr_col_name = self.columns_hash['name'] ? 'name' : 'description'
    order_col_name = self.columns_hash['position'] ? 'position' : 'id'
    self.find(:all,:select=>"id, #{descr_col_name} description",:order=>order_col_name).map { |m| [m.description, m.id ]}
  end  
  
  def save(*args)
    @edit_mode = false # Note edit_mode? will look at errors. 
    save_base(*args)
  end    
end