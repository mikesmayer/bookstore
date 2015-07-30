class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :add_cart
  helper_method :current_cart
  

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

  def check_permissions
    user = current_user || User.new
    unless user.role? "admin"
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
    end
  end

  def current_cart
    @cart ||= Cart.new(session)
  end

  def add_cart
    if session["cart"].nil?
      session["cart"] = {"books" => []}
    end
  end
end
