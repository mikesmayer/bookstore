class OrdersController < ApplicationController
  load_and_authorize_resource :order
  load_and_authorize_resource :book, only: [:add_to_cart, :delete_from_cart]
  
  def index
    @orders = Order.accessible_by(current_ability).all
  end

  def show
  end

  def update
    if params[:button] == "empty_cart" 
      @order.order_books.destroy_all
      redirect_to root_path
    elsif @order.update(order_params)
      flash[:notice] = @order.flash_notice
      redirect_to :back
    else
      flash[:errors] = @order.errors.messages
      redirect_to :back
    end
  end

  def cart
  end

  def add_to_cart
    respond_to do |format|
      if @order.add_book(@book, 1)
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

  def order_params
   params.fetch(:order, {}).permit!#(:user_id, :credit_card_id, :billing_address_id, :shipping_address_id)
  end
end
