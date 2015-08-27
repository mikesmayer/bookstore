require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:country_attributes){FactoryGirl.attributes_for :country}
  let(:address){FactoryGirl.build :address}

  it {should belong_to(:country)}
  it {should have_one(:profile_billing_address).with_foreign_key("billing_address_id")}
  it {should have_one(:profile_shipping_address).with_foreign_key("shipping_address_id")}
  it {should have_many(:orders_billing_addresses).with_foreign_key("billing_address_id")}
  it {should have_many(:orders_shipping_addresses).with_foreign_key("shipping_address_id")}
  it {should validate_presence_of(:user_address)}
  it {should validate_presence_of(:zipcode)}
  it {should validate_presence_of(:city)}
  it {should validate_presence_of(:zipcode)}
  it {should validate_presence_of(:phone)}
  it {should validate_presence_of(:country_id)}
end
