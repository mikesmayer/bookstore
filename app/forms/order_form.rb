class OrderForm
  include ActiveModel::Model

  attr_accessor :billing_equal_shipping, :next_step
  attr_reader :order
  def initialize(order)
    @order = order
  end

  def shipping_address
    @order.shipping_address ||= profile(:shipping_address) || @order.build_shipping_address
  end

  def billing_address
    @order.billing_address  ||= profile(:billing_address)  || @order.build_billing_address
  end

  def delivery
    @order.delivery         ||= @order.build_delivery
  end

  def credit_card
    @order.credit_card      ||= profile(:credit_card)      || @order.build_credit_card
  end

  def update(params)
    if params[:shipping_address]
      shipping_address.assign_attributes(params[:shipping_address])
      billing_address.assign_attributes(params[:billing_address])
      billing_address.assign_attributes(params[:shipping_address]) if billing_equal_shipping?(params)
    elsif params[:delivery]
      @order.assign_attributes(params[:delivery])
    elsif params[:credit_card]
      credit_card.assign_attributes(params[:credit_card])
    end
  end

  def save
    @order.save
  end

  private

  def profile(resource)
    if @order.user.profile.send(resource)
      @order.user.profile.send(resource).dup
    else
      nil
    end
  end


  def billing_equal_shipping?(params)
    params[:billing_equal_shipping] == "1"
  end
end