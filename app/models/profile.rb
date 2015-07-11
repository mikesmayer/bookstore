class Profile < ActiveRecord::Base
  has_one :billing_address,  class_name: "Address", foreign_key: "billing_address_id"
  has_one :shipping_address, class_name: "Address", foreign_key: "shipping_address_id"
  belongs_to :user
  has_one :shipping_address
  has_one :billing_address
end
