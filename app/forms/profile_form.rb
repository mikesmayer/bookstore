class ProfileForm
  include ActiveModel::Model

  attr_reader :profile

  def initialize(profile)
    @profile = profile
  end

  def email
    @profile.email
  end

  def shipping_address
    @profile.shipping_address || @profile.build_shipping_address
  end

  def billing_address
    @profile.billing_address  || @profile.build_billing_address
  end

  def credit_card
    @profile.credit_card      || @profile.build_credit_card
  end

  def submit(params)
    credit_card.assign_attributes(params[:credit_card])
    shipping_address.assign_attributes(params[:shipping_address])
    billing_address.assign_attributes(params[:billing_address])
    @profile.save
  end
end