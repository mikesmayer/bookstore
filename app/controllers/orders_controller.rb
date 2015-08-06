class OrdersController < ApplicationController
  before_action :add_temp_order, only: :add_to_cart
  load_and_authorize_resource :order
  
  def index
    @orders = Order.accessible_by(current_ability).all
  end

  def show
  end

  def new
    @order = current_user.orders.new
  end

  def edit
  end

  def create
  end

  def cart
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
    @order = Order.find(params[:id])
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def order_params
   params.fetch(:order, {}).permit!#(:user_id, :credit_card_id, :billing_address_id, :shipping_address_id)
  end
end
