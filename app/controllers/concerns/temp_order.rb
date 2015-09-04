module TempOrder

  extend ActiveSupport::Concern

  def temp_order
    @temp_order_id = session["order_id"]
  end

  def find_session_order
    order = Order.find_by(id: @temp_order_id)
    order.update(user_id: current_user.id) if order
  end
end