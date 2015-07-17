class Profile < ActiveRecord::Base
  belongs_to :billing_address,  class_name: "Address", foreign_key: "billing_address_id"
  belongs_to :shipping_address, class_name: "Address", foreign_key: "shipping_address_id"
  has_one :credit_card
  belongs_to :user
  accepts_nested_attributes_for :shipping_address, :billing_address, :credit_card
end
