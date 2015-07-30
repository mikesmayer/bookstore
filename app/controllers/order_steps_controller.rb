class OrderStepsController < ApplicationController
  include Wicked::Wizard
  include ResourceBuilder
  before_action :set_order

  steps :shipping, :billing, :paying, :confirmation

  def show
    build_order
    render_wizard
  end

  def update
    build_order
    if @order.last_step? && @order.not_accepted?
      redirect_to :back
    else
      @order.update_attributes(order_step_params)
      render_wizard @order
    end
  end

  private

  def finish_wizard_path
    order_path(@order)
  end

  def order_step_params
    params.fetch(:order, {order_accepted: "0"}).permit(:order_accepted, 
    shipping_address_attributes: [:user_address, :zipcode, :city, :phone, country_attributes: [:name]],
    billing_address_attributes:  [:user_address, :zipcode, :city, :phone, country_attributes: [:name]],
    credit_card_attributes:      [:number, :cvv, :expiration_year, :expiration_month, :first_name, :last_name])
  end

  def set_order
    @order = Order.find(params[:order_id])

    if step  == steps.last
      @order.current_step = "confirmation"
      @order.order_accepted = order_step_params[:order_accepted]
    end
  end
end
