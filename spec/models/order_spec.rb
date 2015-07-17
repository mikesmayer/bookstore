require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:book){FactoryGirl.create :book, quantity: 1}
  let(:order){Order.new}
  it "does something" do
    p book
    order.ordered_books = [{"id" => "1", "quantity" => "1", "price" => "10"}]
    order.save
    puts "Order"
    p Order.first
    puts "OrderIitem"
    p OrderBook.all
    puts "Books"
    p Order.first.books
  end
end
