class Order < ActiveRecord::Base
  include AASM
  attr_accessor :current_step, :ordered_books, :order_accepted
  belongs_to :user
  belongs_to :credit_card
  belongs_to :billing_address,  class_name: "Address", foreign_key: "billing_address_id"
  belongs_to :shipping_address, class_name: "Address", foreign_key: "shipping_address_id"
  has_many   :order_books
  has_many   :books, through: :order_books

  accepts_nested_attributes_for :shipping_address, :billing_address, :credit_card
  validates_associated :shipping_address, :billing_address, :credit_card
  validates :shipping_address, :billing_address, :credit_card, presence: true,  if: :last_step?

  aasm column: :status do
      state :initializing, :initial => true
      state :creating
      state :processing
      state :shipping
      state :done

      event :add_books do
        transitions :from => :initializing, :to => :creating
      end

      event :add_order_info do
        transitions :from => :creating, :to => :processing
      end

      event :send_order do
        transitions :from => :processing, :to => :shipping
      end

      event :get_order do
        transitions :from => :shipping, :to => :done
      end
    end

#OrderBook relations
  before_save do
    if self.initializing?
      self.order_books << OrderBook.create(book_order_params)
      self.total_price = self.order_books.inject(0){|t_p, b| t_p + b.quantity*b.price}
      self.add_books
    elsif last_step? && self.creating?
       self.completed_date = DateTime.now
       self.add_order_info
    end
  end


  def book_order_params
    book_order_params_collection = []
    @ordered_books.each do |book|
      book_order_params = {}
      if book_exist?(book["id"].to_i, book["quantity"].to_i)
        book_order_params[:order_id]    = self.id
        book_order_params[:book_id]     = book["id"].to_i
        book_order_params[:quantity]    = book["quantity"].to_i
        book_order_params[:price]       = book["price"].to_f
        book_order_params_collection << book_order_params
      end
    end

    book_order_params_collection
  end

  def book_exist?(id, quantity)
    book = Book.select{|book| book.id == id}.first
    if book != nil
      if book.quantity >= quantity
        new_quantity = book.quantity - quantity
        book.update!(quantity: new_quantity)
        return true
      else
        return false
      end
    else
      false
    end
  end

  def last_step?
    if @current_step == "confirmation"
      true
    else
      false
    end
  end

  def not_accepted?
    @order_accepted == "0"
  end

  def quantity_in_order(book)
    self.order_books.find_by(book_id: book.id).quantity
  end
 end
