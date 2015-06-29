module ApplicationHelper
   def devise_error_messages!
     flash[:error] = resource.errors.full_messages.join('<br />')
     return ''
   end
end
