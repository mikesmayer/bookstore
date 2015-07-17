module OrdersHelper

  def user_address
    @order.shipping_address.user_address
  end
end
