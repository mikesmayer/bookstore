module ResourceBuilder

  extend ActiveSupport::Concern

  def build_profile
    @profile = current_user.profile
    @profile.shipping_address         || @profile.build_shipping_address
    @profile.billing_address          || @profile.build_billing_address
    @profile.credit_card              || @profile.build_credit_card
    @profile.shipping_address.country || @profile.shipping_address.build_country
    @profile.billing_address.country  || @profile.billing_address.build_country
  end
end