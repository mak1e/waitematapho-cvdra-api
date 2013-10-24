# Enhance the InstanceTag helpers to add uppercase and grouping on selects
class ActionView::Helpers::InstanceTag
  alias to_input_field_tag_base to_input_field_tag
  alias to_select_tag_base to_select_tag
  
  def to_input_field_tag(field_type, options = {})
    if ( options.has_key?(:upcase) ) 
      options.delete(:upcase )  
      options.merge!({:style => 'text-transform:uppercase;', 
                      :onkeyup => 'javascript:this.value.search(/[a-z]/)>=0?this.value=this.value.toUpperCase():void 0;' } )  
    end
    to_input_field_tag_base(field_type, options)
  end
  
   
  def options_for_select_with_group(container, selected = nil)
   html = '';
   optgroup=''
   for element in container do
     if ( optgroup != element[2] ) # group changed
       html += '</optgroup>' unless optgroup.blank?
       optgroup = element[2]
       html += "<optgroup label=\"#{optgroup}\">" unless optgroup.blank?
     end
     is_selected = element[1] == selected ? ' selected="selected"' : ''
     html += "<option value=\"#{element[1].to_s}\" #{is_selected}>#{element[0].to_s}</option>"
   end
   html += '</optgroup>' unless optgroup.blank?
   html
  end   
   
  def to_select_tag(choices, options, html_options)
     if ( options.has_key?(:with_group) ) 
       html_options = html_options.stringify_keys
       add_default_name_and_id(html_options)
       value = value(object)
       selected_value = options.has_key?(:selected) ? options[:selected] : value
       options.delete(:with_group ) 
       content_tag("select", add_options(options_for_select_with_group(choices, selected_value), options, selected_value), html_options)
     else
       to_select_tag_base(choices, options, html_options)
     end
  end
end


