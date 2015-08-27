require 'rails_helper'

RSpec.describe OrderBook, type: :model do
  let(:book){FactoryGirl.create :book, quantity: 3}
  let(:order_book){OrderBook.create(quantity: 2, book_id: book.id)}

  it {should belong_to(:book)}
  it {should belong_to(:order)}

  describe "#increase_book_quantity?" do
    context "order_book is new record" do
      it "returns true" do
        expect(subject.increase_book_quantity?).to eq true
      end
    end

    context "order_book doesn't new record" do
      context "new quantity < quantity" do
        it "returns false" do
          order_book.quantity = 1
          expect(order_book.increase_book_quantity?).to eq false
        end
      end

      context "new quantity > quantity" do
        it "returns true" do
          order_book.quantity = 3
          expect(order_book.increase_book_quantity?).to eq true
        end
      end
    end
  end

  describe "#book_quantity" do
    context "book quantity > books in stock" do
      it "is invalid" do
        order_book.quantity = 5
        expect(order_book).not_to be_valid
      end
    end

    context "book quantity > books in stock" do
      it "is valid" do
        order_book.quantity = 3
        expect(order_book).to be_valid
      end
    end
  end
end
