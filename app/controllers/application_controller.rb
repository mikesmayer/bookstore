class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :add_temp_order, :set_order
  after_action  :stored_location
  rescue_from CanCan::AccessDenied, Wicked::Wizard::InvalidStepError, with: :generate_route

  
  def stored_location
    session[:previous_url] = request.fullpath unless request.fullpath.match(/\/(login|auth|register|add_to_cart)/)
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || request.referer || root_path
  end

  def generate_route(exception)
    if RouteAccessErrors.call(exception)
      redirect_to new_user_session_path
    else
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
    end
  end

  private

  def add_temp_order
    if current_user && Order.find_by(user_id: current_user, status: "in_progress").nil?
      Order.create(user_id: current_user.id)
    elsif session["order_id"].nil?
      session["order_id"] = Order.create.id
    end
  end

  def set_order
    if current_user
      @order_as_cart = Order.where(user_id: current_user.id, status: "in_progress").last
    else
      @order_as_cart = Order.find_by(id: session["order_id"])
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, session)
  end
end
