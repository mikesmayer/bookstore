class OrdersController < ApplicationController
  load_and_authorize_resource

  def index
    @orders = Order.accessible_by(current_ability).all
  end

  def show
  end

  def new
     redirect_to(cart_books_path) if session["cart"]["books"].empty?
     session[:order_params] ||= {}
     @order = Order.new(session["order_params"])
     build_order
     @order.current_step = session["order_step"]
  end

  def edit
  end

  def create

    session["order_params"].merge!(order_params) if order_params 

    @order = Order.new(session["order_params"])
    @order.current_step = session["order_step"]

    if params[:back_button]
      @order.previous_step
    elsif @order.last_step?
      @order.user_id = current_user.id
      @order.ordered_books = session["cart"]["books"]
      @order.save
    else
      if step_valid?
        @order.next_step
      end
    end
    session["order_step"] = @order.current_step
    if @order.new_record?
      build_order
      render action: "new"
    else
      session["order_step"] = session["order_params"] = nil
      flash[:notice] = "Order saved."
      redirect_to order_path(@order)
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

    def step_valid?
      if @order.current_step == "shipping"
         unless @order.shipping_address.valid?
            @order.errors.messages.merge!(@order.shipping_address.errors.messages)
            return false
         end
      elsif @order.current_step == "billing"
         unless @order.billing_address.valid?
            @order.errors.messages.merge!(@order.billing_address.errors.messages)
            return false
         end
      elsif @order.current_step == "paying"
         unless @order.credit_card.valid?
            @order.errors.messages.merge!(@order.credit_card.errors.messages)
            return false
         end
      end
      true
    end

    def set_order
      @order = Order.new
    end

    def build_order
      @profile = current_user.profile if current_user
      @order.shipping_address || @order.build_shipping_address#(session["order_params"]["shipping_address"])
      @order.billing_address  || @order.build_billing_address
      @order.credit_card      ||  @order.build_credit_card 
      @order.shipping_address.country ||  @order.shipping_address.build_country
      @order.billing_address.country  ||  @order.billing_address.build_country
    end

    def order_params
      #params[:order]
     params.fetch(:order, {}).permit!#(:user_id, :credit_card_id, :billing_address_id, :shipping_address_id
                                    #)
    end
end
