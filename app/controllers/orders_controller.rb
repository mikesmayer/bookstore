class OrdersController < ApplicationController
  load_and_authorize_resource
  
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
    @order = current_user.orders.new
    @order.ordered_books = session["cart"]["books"]
    if @order.ordered_books.empty?
      redirect_to new_order_path 
    elsif @order.save!
      session["cart"]["books"].clear
      redirect_to order_order_steps_path(@order)
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
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

  def set_order
    @order = Order.new
  end

  def order_params
   params.fetch(:order, {}).permit(:user_id, :credit_card_id, :billing_address_id, :shipping_address_id)
  end
end
