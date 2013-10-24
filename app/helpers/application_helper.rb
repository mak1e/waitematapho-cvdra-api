# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def popup_options
   'scrollbars=yes, menubar=yes, resizable=yes,toolbar=yes,width=640,height=480'
  end
  
  def popup_dialogue_options
   'scrollbars=yes, menubar=no,status=no,resizable=yes,toolbar=no,width=420,height=320'
  end
  
  def lessgst_pre_GST(amount)
   ( "%.2f" % (amount.to_f / ( 1 + Settings::GST_PRE ))).to_f 
  end
  
  def lessgst_post_GST(amount)
   ( "%.2f" % (amount.to_f / ( 1 + Settings::GST_POST ))).to_f 
  end
  
  #
  # This is no longer needed in rails 2.1 as now can use error_messages_for :object => x
  # def error_messages_for :object =>(object)
  #    if object && !(e = object.errors).empty?
  #      header_message = "#{pluralize(e.count, 'error')} prohibited this #{object.class.to_s.underscore.humanize } from being saved"
  #      error_messages = e.full_messages.map {|msg| content_tag(:li, msg) }
  #      content_tag(:div, 
  #        content_tag(:h2, header_message) <<
  #          content_tag(:p, 'There were problems with the following fields:') <<
  #           content_tag(:ul, error_messages),
  #           { :class => 'errorExplanation', :id => 'errorExplanation'}
  #       )
  #    else
  #      ''
  #    end
  # end;
  
end
