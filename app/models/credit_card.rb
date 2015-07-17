class CreditCard < ActiveRecord::Base
  belongs_to :profile
  has_many   :orders
  validates :number, :cvv, :expiration_month, :expiration_year, 
            :first_name, :last_name, presence: true
end
