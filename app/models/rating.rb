# class Rating < ActiveRecord::Base
#   belongs_to :user
#   belongs_to :book
  
#   validates :review, :rating_number, presence: true
#   validates :rating_number, numericality: { only_integer: true, greater_than: 0, less_than: 11 }
# end
