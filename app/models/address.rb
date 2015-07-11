class Address < ActiveRecord::Base
  belongs_to :profile
  belongs_to :country
  has_many   :orders
  validates  :customer_address, :city, :zipcode, :phone,  presence: true
end
