require 'rails_helper'

RSpec.describe OrderBook, type: :model do
  let(:book){FactoryGirl.create :book, quantity: 3}

  it {should belong_to(:book)}
  it {should belong_to(:order)}

  it "does something" do
   o =  OrderBook.create({book_id: book.id, order_id: 1, quantity: 5})
   #p o.update(quantity: 1)
  end


end
