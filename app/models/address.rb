class Address < ActiveRecord::Base
  has_many :profile_shipping_addresses, class_name: "Profile", foreign_key: "shipping_address_id"
  has_many :profile_billing_addresses,  class_name: "Profile", foreign_key: "billing_address_id"
  belongs_to :country
  has_many :order_shipping_addresses, class_name: "Order", foreign_key: "shipping_address_id"
  has_many :order_billing_addresses,  class_name: "Order", foreign_key: "billing_address_id"
  validates  :user_address, :city, :zipcode, :phone, :first_name, :last_name,  presence: true
end
