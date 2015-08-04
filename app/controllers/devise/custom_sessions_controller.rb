class Devise::CustomSessionsController  < Devise::SessionsController
  before_action :temp_order, only: :create
  after_action  :find_session_order, only: :create

  def temp_order
    @temp_order = session["temp_order"]
  end

  def find_session_order
    order = Order.find_by(session_id: @temp_order)  
    order.update(user_id: current_user.id, session_id: session["session_id"]) if order
  end
end
