class OrdersController < ApplicationController
  load_and_authorize_resource :order
  load_and_authorize_resource :book, only: [:add_to_cart, :delete_from_cart]
  
  def index
    @orders = Order.accessible_by(current_ability).all
  end

  def show
  end

  def update
    @order.order_books.destroy_all if params[:button] == "empty_cart"
    if @order.update(order_params)
      flash[:notice] = @order.flash_notice
    else
      flash[:errors] = @order.errors.messages
    end
    redirect_to :back
  end

  def cart
  end

  def add_to_cart
    respond_to do |format|
      if @order.add_book(@book, book_quantity)
        format.js
      else 
        flash[:notice] = @book.errors
        format.js
      end
    end
  end

  def delete_from_cart
    @order.delete_book(@book)
    redirect_to :back
  end

  def cancel
    @order.cancel!
    redirect_to :back
  end

  private

  def book_quantity
   CalculateBookQuantity.call(params[:book])
  end

  def order_params
   params.fetch(:order, {}).permit!#(:user_id, :credit_card_id, :billing_address_id, :shipping_address_id)
  end
end
