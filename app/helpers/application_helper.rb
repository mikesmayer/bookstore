module ApplicationHelper

  # def current_user
  #   current_user ||= User.new
  # end
  
   def devise_error_messages!
     flash[:error] = resource.errors.full_messages.join('<br />')
     return ''
   end

end
