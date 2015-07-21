require 'rails_helper'

RSpec.describe Profile, type: :model do
  it{should belong_to(:billing_address).with_foreign_key("billing_address_id")}
  it{should belong_to(:shipping_address).with_foreign_key("shipping_address_id")}
  it{should have_one(:credit_card)}
  it{should belong_to(:user)}
  it{should accept_nested_attributes_for(:shipping_address)}
  it{should accept_nested_attributes_for(:billing_address)}
  it{should accept_nested_attributes_for(:credit_card)}
end
