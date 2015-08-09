class OrdersController < ApplicationController
  load_and_authorize_resource :order
  load_and_authorize_resource :book, only: [:add_to_cart, :delete_from_cart]
  before_action :set_order, only: :index
  
  def index
    @orders = Order.accessible_by(current_ability).all
  end

  def show
  end

  def update
    respond_to do |format|
      if params[:button] == "empty_cart" 
        @order.order_books.destroy_all
        format.html {redirect_to root_path}
      elsif @order.update(order_params)
        format.html { redirect_to :back}
      else
        format.html do 
          flash[:errors] = @order.errors.messages
          redirect_to :back
        end
      end
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully destroyed.'
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

  private
  
  def set_order
    if current_user
      @order = Order.where(user_id: current_user.id, status: "in_progress").last
    else
      @order = Order.find_by(id: session["order_id"])
    end
  end

  def order_params
   params.fetch(:order, {}).permit!#(:user_id, :credit_card_id, :billing_address_id, :shipping_address_id)
  end
end
