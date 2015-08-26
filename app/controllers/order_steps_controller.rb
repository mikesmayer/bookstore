class OrderStepsController < ApplicationController
  include Wicked::Wizard
  load_resource :order
  before_action :build_order_form, only: [:show, :update]
  before_action :set_steps
  before_action :setup_wizard
  

  def show
    authorize! :show, @order
    render_wizard 
  end

  def update
    authorize! :update, @order
    @order_form.update(order_step_params)
    set_steps
    setup_wizard
    render_wizard @order_form

  end

  private

  def order_step_params
    params.fetch(:order_form, {order_accepted: "0"}).permit(:order_accepted, :billing_equal_shipping,
    shipping_address: [:first_name, :last_name, :user_address, :zipcode, :city, :phone, :country_id],
    billing_address:  [:first_name, :last_name, :user_address, :zipcode, :city, :phone, :country_id],
    credit_card:      [:number, :cvv, :expiration_year, :expiration_month, :first_name, :last_name],
    delivery:         [:delivery_id])
  end

  def build_order_form
    @order_form = OrderForm.new(@order)
  end

  def set_steps
    self.steps = @order.available_steps
  end

  def finish_wizard_path
    @order.set_in_process!
    Order.create(user_id: current_user.id)
    orders_path
  end
end
