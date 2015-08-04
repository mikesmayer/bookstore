module OrdersHelper

  # def user_address
  #   @order.shipping_address.user_address
  # end

  def build_cart
    @cart = Order.find_by(session_id: session["temp_order"])
  end

  def can_build_cart?
    Order.find_by(session_id: session["temp_order"]) != nil
  end
end
