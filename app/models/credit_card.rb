class CreditCard < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile
  has_many   :orders, dependent: :destroy
  validates :number, :cvv, :expiration_month, :expiration_year, 
            :first_name, :last_name, presence: true
  validates_numericality_of :expiration_year, 
                            greater_than_or_equal_to: Time.now.year
  validates_numericality_of :expiration_month, 
                            greater_than_or_equal_to: Time.now.month

end