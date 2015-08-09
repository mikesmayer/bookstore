class OrderStepsController < ApplicationController
  include Wicked::Wizard
  include ResourceBuilder
  load_and_authorize_resource :order

  before_action :set_steps
  before_action :setup_wizard

  def show
    build_order
    render_wizard 
  end

  def update
    @order.update_attributes(order_step_params)
    set_steps
    setup_wizard
    render_wizard @order
  end

  private

  def order_step_params
    params.fetch(:order, {order_accepted: "0"}).permit(:order_accepted, :billing_equal_shipping,
    shipping_address_attributes: [:first_name, :last_name, :user_address, :zipcode, :city, :phone, :country_id],
    billing_address_attributes:  [:first_name, :last_name, :user_address, :zipcode, :city, :phone, :country_id],
    credit_card_attributes:      [:number, :cvv, :expiration_year, :expiration_month, :first_name, :last_name],
    delivery_attributes: [:delivery_id])
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
