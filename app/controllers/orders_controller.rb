class OrdersController < ApplicationController
  before_action :set_order, :build_order, only: [ :show, :edit, :update, :destroy]
  

  #before_action :check_permissions, only: [:new, :edit, :update, :destroy, :create]

  # GET /orders
  # GET /orders.json
  def index
    if current_user && current_user.role?("admin")
      @orders = Order.all
    else
      @orders = Order.where(user_id: current_user.id)
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    redirect_to new_user_session_path, notice: 'You should log in for creating order' unless current_user
     session[:order_params] ||= {}
     @order = Order.new(session[:order_params])
     build_order
     @order.current_step = session[:order_step]
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    session[:order_params].merge!(order_params) if order_params
    @order = Order.new(session[:order_params])
    @order.current_step = session[:order_step]

    if params[:back_button]
      @order.previous_step
    elsif @order.last_step?
      @order.user_id = current_user.id
      @order.ordered_books = session["cart"]["books"]
      @order.save
    else
      if @order.valid?
        @order.next_step
      end
    end
    session[:order_step] = @order.current_step
    if @order.new_record?
      build_order
      render 'new'
    else
      session[:order_step] = session[:order_params] = nil
      flash[:notice] = "Order saved."
      redirect_to order_path(@order)
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
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

  # DELETE /orders/1
  # DELETE /orders/1.json
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

    def build_order
      @profile = current_user.profile if current_user
      @order.shipping_address || @order.build_shipping_address
      @order.billing_address  || @order.build_billing_address
      @order.credit_card      ||  @order.build_credit_card 
      @order.shipping_address.country ||  @order.shipping_address.build_country
      @order.billing_address.country  ||  @order.billing_address.build_country
    end

    def chek_user
      #redirect_to new_user_session_path, notice: 'You should log in for creating order' unless current_user 
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
     params[:order]# => .require(:order)#.permit!#(:user_id, :credit_card_id, :billing_address_id, :shipping_address_id
                                    #)
    end
end
