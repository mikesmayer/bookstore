class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :category
  validates  :title, :description, :quantity, :price, 
             :category_id, :author_id, presence: true
  validates  :price, :quantity, numericality: {greater_than: 0}
  
end
