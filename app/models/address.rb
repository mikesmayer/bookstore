class Address < ActiveRecord::Base
  belongs_to :country
  has_many :shipping_addresses, foreign_key: "shipping_address_id"
  has_many :billing_addresses, foreign_key: "billing_address_id"
  validates  :user_address, :city, :zipcode, :phone, :first_name, :last_name, :country_id,  presence: true
  accepts_nested_attributes_for :country
end
