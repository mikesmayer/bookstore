class Profile < ActiveRecord::Base
  belongs_to :billing_address,  class_name: "Address", autosave: true
  belongs_to :shipping_address, class_name: "Address", autosave: true
  has_one :credit_card, autosave: true
  belongs_to :user
end
