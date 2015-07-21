require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:book){FactoryGirl.create :book, quantity: 4}
  let(:order){FactoryGirl.build :order}


  it{should belong_to(:user)}
  it{should belong_to(:credit_card)}
  it{should belong_to(:shipping_address).with_foreign_key(:shipping_address_id)}
  it{should belong_to(:billing_address).with_foreign_key(:billing_address_id)}
  it{should have_many(:order_books)}
  it{should have_many(:books).through(:order_books)}
  it{should accept_nested_attributes_for(:shipping_address)}
  it{should accept_nested_attributes_for(:billing_address)}
  it{should accept_nested_attributes_for(:credit_card)}
  

  describe "instance variables" do
    it {expect(subject).to respond_to(:current_step)}
    it {expect(subject).to respond_to(:ordered_books)}
  end

  describe "#steps" do
    it {expect(subject.steps).to eq(%w[shipping billing paying confirmation])}
  end

  describe "#next_step" do
    it "set @current_step to next step" do
      subject.current_step = "shipping"
      subject.next_step
      expect(subject.current_step).to eq("billing")
    end
  end

  describe "#previous_step" do
    it "set @current_step to previous step" do
      subject.current_step = "billing"
      subject.previous_step
      expect(subject.current_step).to eq("shipping")
    end
  end

  describe "#first_step?" do
    context "current step isn'n first step" do
      it "return false" do
        subject.current_step = "billing"
        expect(subject.first_step?).to eq(false)
      end
    end

    context "current step is first step" do
      it "return true" do
        subject.current_step = "shipping"
        expect(subject.first_step?).to eq(true)
      end
    end
  end

  describe "#last_step?" do
    context "current step isn'n last step" do
      it "return false" do
        subject.current_step = "billing"
        expect(subject.last_step?).to eq(false)
      end
    end

    context "current step is last step" do
      it "return true" do
        subject.current_step = "confirmation"
        expect(subject.last_step?).to eq(true)
      end
    end
  end

  describe "#creation_in_progress?" do
    context "current_step is confirmation step" do
      it "return false" do
        subject.current_step = "confirmation"
        expect(subject.creation_in_progress?).to eq(false)
      end

      context "current_step isn't confirmation step" do
        it "return true" do
          subject.current_step = "billing"
          expect(subject.creation_in_progress?).to eq(true)
        end
      end
    end
  end

  describe "before_save" do
    before do
      allow(order).to receive(:book_exist?).and_return(true)
    end
    it "creates new order_book object" do
      
      expect{order.run_callbacks(:save){false}}.to change{OrderBook.count}.by(1)
    end

    it "adds to to order_books ordered book" do
      #allow(order).to receive(:book_exist?)
      expect{order.save}.to change{order.order_books.count}.by(1)
    end

    it "writes to completed_date order creating date" do
      order.save
      expect(order.completed_date).to be_a(ActiveSupport::TimeWithZone)
    end

    it "writes to order.status 'processed'" do
      order.save
      expect(order.status).to eq('processed')
    end

    it "call #book_order_params" do
      allow(order.order_books).to receive(:inject)
      expect(order).to receive(:book_order_params)
      order.run_callbacks(:save){false}
    end
  end

  describe "#book_order_params" do 
    it "call #book_exists" do
      expect(order).to receive(:book_exist?)
      order.run_callbacks(:save){false}
    end

    it "return an array with params for order_books" do
      ordered_book = order.ordered_books.first
      expect(order.book_order_params).to eq([{order_id: order.id, 
                                              book_id:  ordered_book["id"],
                                              quantity: ordered_book["quantity"],
                                              price:    0 }])
    end
  end

  describe "#book_exists?" do
    context "book exists" do
      context "#book.quantity >= orderdered quantity" do
        it "increases quantity of Book by ordered quantity" do
          order.book_exist?(book.id, book.quantity - 1)
          expect(Book.find(book.id).quantity).to eq(1)
        end

        it "returns true" do
          expect(order.book_exist?(book.id, book.quantity)).to eq(true)
        end
      end

      context "#book.quantity <= orderdered quantity" do
        it "returns false" do
          expect(order.book_exist?(book.id, book.quantity + 1)).to eq(false)
        end
      end
    end
    context "book doesn't exist" do
      it "returns false" do
        expect(order.book_exist?(999, book.quantity + 1)).to eq(false)
      end
    end
  end
end
