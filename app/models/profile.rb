class Profile < ActiveRecord::Base
  belongs_to :billing_address,  class_name: "Address", foreign_key: "billing_address_id", autosave: true
  belongs_to :shipping_address, class_name: "Address", foreign_key: "shipping_address_id", autosave: true
  has_one :credit_card, autosave: true
  belongs_to :user
end
