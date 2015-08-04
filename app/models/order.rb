class Order < ActiveRecord::Base
  include AASM
  attr_accessor :current_step, :ordered_books, :order_accepted, :available_steps, :order_steps
  belongs_to :user
  belongs_to :credit_card
  belongs_to :billing_address,  class_name: "Address", foreign_key: "billing_address_id"
  belongs_to :shipping_address, class_name: "Address", foreign_key: "shipping_address_id"
  has_many   :order_books, dependent: :destroy
  has_many   :books, through: :order_books

  accepts_nested_attributes_for :shipping_address, :billing_address, :credit_card, :order_books
  validates_associated :shipping_address, :billing_address, :credit_card
  validates :shipping_address, :billing_address, :credit_card, presence: true,  if: :last_step?

  scope :as_cart, ->(session_id) { where('session_id = ?', session_id).last }

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

  def last_step?
    if @current_step == "confirmation"
      true
    else
      false
    end
  end

  # def not_accepted?
  #   @order_accepted == "0"
  # end

  before_save do
    total_price
  end

  def total_price
    self.total_price = self.order_books.inject(0){|t_p, b| t_p + b.quantity*b.price}
  end

  def add_book(book, quantity)
    if order_book = self.order_books.find_by(book_id: book.id)
      order_book.quantity += quantity
      order_book.save
    else
      OrderBook.create(order_book_params(book, quantity))
    end
  end

  def delete_book(book)
    self.order_books.find_by(book_id: book.id).destroy
  end

  def quantity_in_order(book)
    self.order_books.find_by(book_id: book.id).quantity
  end

  def order_book_params(book, quantity)
    {order_id: self.id, book_id: book.id, quantity: 1, price: book.price}
  end

  def self.temp_order_for_visitor(sesion)
    Order.create(session_id: session["session_id"])
  end


  def order_steps
    {shipping:     true, 
     billing:      self.shipping_address.nil? ? false : self.shipping_address.valid?,
     paying:       self.billing_address.nil?  ? false : self.billing_address.valid?,
     confirmation: self.credit_card.nil?      ? false : self.credit_card.valid?}
  end

  def available_steps
    steps = [ ]
    order_steps.each{|step, passed| steps << step if passed == true}
    steps
  end
 end
