class Devise::CustomOmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :temp_order, only: :facebook
  after_action  :find_session_order, only: :facebook

  def temp_order
    @temp_order_id = session["order_id"]
  end

  def find_session_order
    order = Order.find_by(id: @temp_order_id)
    order.update(user_id: current_user.id) if order && current_user
  end
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication 
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
   end
end