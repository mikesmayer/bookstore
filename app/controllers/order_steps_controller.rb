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
    if @order.last_step? && @order.not_accepted?
      redirect_to :back
    else
      @order.update_attributes(order_step_params)
      set_steps
      setup_wizard
      render_wizard @order
    end
  end

  private

  def order_step_params
    params.fetch(:order, {order_accepted: "0"}).permit(:order_accepted, 
    shipping_address_attributes: [:user_address, :zipcode, :city, :phone, country_attributes: [:name]],
    billing_address_attributes:  [:user_address, :zipcode, :city, :phone, country_attributes: [:name]],
    credit_card_attributes:      [:number, :cvv, :expiration_year, :expiration_month, :first_name, :last_name])
  end

  def set_steps
    self.steps = @order.available_steps
  end
end
