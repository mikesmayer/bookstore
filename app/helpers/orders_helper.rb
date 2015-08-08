module OrdersHelper

  def can_build_cart?
     @order.is_a? Order
  end


  def cart_main_panel
    if @order.nil? || @order.books.first.nil?
      "(EMPTY)"
    else
      "(#{cart_books_quantity}/$#{@order.total_price.round(2)})"
    end
  end
end
