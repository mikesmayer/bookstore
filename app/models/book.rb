class Book < ActiveRecord::Base
  validates :title, :description, :quantity, :price, presence: true
  validates :price, :quantity, numericality: {greater_than: 0}
end
