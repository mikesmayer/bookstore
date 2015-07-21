class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  validates :text, :rating, presence: true 
  validates :rating, numericality: { only_integer: true, greater_than: 0, less_than: 6 }
end
