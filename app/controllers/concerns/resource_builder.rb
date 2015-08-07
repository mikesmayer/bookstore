module ResourceBuilder

  extend ActiveSupport::Concern

  def build_order
    @profile = current_user.profile if current_user
    @order.shipping_address         || @order.build_shipping_address
    @order.billing_address          || @order.build_billing_address
    @order.credit_card              || @order.build_credit_card 
    @order.shipping_address.country || @order.shipping_address.build_country
    @order.billing_address.country  || @order.billing_address.build_country
    @order.delivery                 || @order.build_delivery
  end


  def build_profile
    @profile = current_user.profile
    @profile.shipping_address         || @profile.build_shipping_address
    @profile.billing_address          || @profile.build_billing_address
    @profile.credit_card              || @profile.build_credit_card
    @profile.shipping_address.country || @profile.shipping_address.build_country
    @profile.billing_address.country  || @profile.billing_address.build_country
  end
end