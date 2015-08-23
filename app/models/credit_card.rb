class CreditCard < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile
  has_many   :orders, dependent: :destroy
  validates :number, :cvv, :expiration_month, :expiration_year, presence: true
  validates_numericality_of :expiration_year, 
                            greater_than_or_equal_to: Time.now.year
  validates_numericality_of :expiration_month
  validate :expiration_month_in_future, if: :current_year?

  def current_year?
    expiration_year == Time.now.year
  end

  def expiration_month_in_future
    if expiration_month && (expiration_month < Time.now.month) 
      errors.add(:expiration_month, "should be greater or equal than #{Time.now.month}")
    end
  end
end
