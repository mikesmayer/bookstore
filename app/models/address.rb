class Address < ActiveRecord::Base
  has_many    :orders_billing_addresses,  class_name: "Order",   foreign_key: "billing_address_id"
  has_many    :orders_shipping_addresses, class_name: "Order",   foreign_key: "shipping_address_id"
  has_one     :profile_billing_address,   class_name: "Profile", foreign_key: "billing_address_id"
  has_one     :profile_shipping_address,  class_name: "Profile", foreign_key: "shipping_address_id"

  belongs_to  :country
  validates   :user_address, :city, :zipcode, :phone, 
              :first_name,   :last_name, :country_id,  presence: true
  attr_accessor :country_attributes
end
