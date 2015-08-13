module OrdersHelper

  def can_build_cart?
    @order.is_a? Order
  end

  def cart_order
    if current_user
      Order.where(user_id: current_user.id, status: "in_progress").last
    else
      Order.where(id: session["order_id"]).last
    end
  end


  def cart_main_panel
    if cart_order.total_price != 0
      "(#{cart_books_quantity}/$#{cart_order.total_price.round(2)})"
    else
      "(EMPTY)"
    end
  end
end
