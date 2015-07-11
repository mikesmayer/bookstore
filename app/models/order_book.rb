class OrderBook < ActiveRecord::Base
  belongs_to :book
  belongs_to :order
end
