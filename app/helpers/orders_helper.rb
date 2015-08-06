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

  def cart_main_panel
    if @order.nil? || @order.books.first.nil?
      "(EMPTY)"
    else
      "(#{@order.books.length}/$#{@order.total_price.round(2)})"
    end
  end
end
