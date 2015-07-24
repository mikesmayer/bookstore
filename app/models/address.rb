class Address < ActiveRecord::Base
  has_many :profile_shipping_addresses, class_name: "Profile", foreign_key: "shipping_address_id"
  has_many :profile_billing_addresses,  class_name: "Profile", foreign_key: "billing_address_id"
  belongs_to :country
  has_many :order_shipping_addresses, class_name: "Order", foreign_key: "shipping_address_id"
  has_many :order_billing_addresses,  class_name: "Order", foreign_key: "billing_address_id"
  accepts_nested_attributes_for :country, reject_if: :country_exists?
  validates  :user_address, :city, :zipcode, :phone,  presence: true

  def country_exists?(country_attr)
    if country = Country.find_by_name(country_attr[:name])
      self.country_id = country.id
      true
    end
  end
end
