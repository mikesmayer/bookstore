class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :stored_location
  # helper_method :current_cart
  
  def stored_location
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/login/
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || request.referer || root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    if exception.action == :index
      subject = exception.subject
      if (subject == Review) || (subject == Category) || (subject == Book) || (subject==Author)
        render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
      else
        redirect_to new_user_session_path
      end
    else
      if (exception.subject.kind_of? Review) && (exception.action != :update_status)
        redirect_to new_user_session_path
      elsif exception.subject.kind_of? Order
        redirect_to new_user_session_path
      elsif (exception.subject.kind_of? Book) && (exception.action == :add_to_wish_list)
        redirect_to new_user_session_path
      else
        render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
      end
    end
  end

  private

   def current_ability
    @current_ability ||= Ability.new(current_user, session)
  end
end
