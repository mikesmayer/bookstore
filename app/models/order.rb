class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :credit_card
  belongs_to :billing_address,  class_name: "Address", foreign_key: "billing_address_id"
  belongs_to :shipping_address, class_name: "Address", foreign_key: "shipping_address_id"
  has_many   :order_books
  has_many   :books, through: :order_items

  validates :total_price, :status, presence: true
  validates :completed_date, presence: true, if: :status_completed?
  validates :status, inclusion: {in: %w(in\ progress completed shipped)}

  before_validation do
    self.status ||= "in progress"
    self.total_price ||= 0
  end 

  def status_completed?
    true if self.status == "completed"
  end

  def add_book(params = {})
    params[:order_id] = self.id
    OrderItem.create(params)
    unless self.order_items(true).empty?
      self.total_price = self.order_items(true).inject(0){|t_price, position| t_price + position.quantity*position.price} 
    end
  end
end
