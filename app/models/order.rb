class Order < ActiveRecord::Base
  include AASM
  attr_accessor :current_step,  :order_accepted, :billing_equal_shipping
  belongs_to :user
  belongs_to :credit_card
  belongs_to :billing_address,  class_name: "Address", foreign_key: "billing_address_id"
  belongs_to :shipping_address, class_name: "Address", foreign_key: "shipping_address_id"
  has_many   :order_books, dependent: :destroy
  has_many   :books, through: :order_books
  has_one    :coupon
  belongs_to :delivery

  accepts_nested_attributes_for :shipping_address, :credit_card, :order_books
  accepts_nested_attributes_for :billing_address, reject_if: :equal_shipping_address?
  #validates_associated :shipping_address, :billing_address, :credit_card
  validates :shipping_address, :billing_address, :credit_card, presence: true,  if: :last_step?

  #scope :as_cart, ->(session_id) { where('session_id = ? AND status = ?', session_id, "initializing" ).take}
  # scope :as_cart, ->(order_id) { where('id = ? AND status = ?', order_id, "initializing" ).take}
  # scope :as_carts, -> { where('status = ?', "initializing" )}

  aasm column: :status do
      state :in_progress, :initial => true
      state :in_process
      state :shipping
      state :done
      state :canceled
      state :rejected
      state :done

      event :set_in_process do
        before do
          self.completed_date = DateTime.now
        end
        transitions :from => :in_progress, :to => :in_process
      end

      event :set_in_shipping do
        transitions :from => :in_process, :to => :shipping
      end

      event :set_in_done do
        transitions :from => :shipping, :to => :done
      end

      event :cancel do
        transitions :from => :in_process, :to => :canceled
      end

      event :reject do
        transitions :from => :in_process, :to => :reject
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
    set_coupon
    self.billing_address = self.shipping_address if equal_shipping_address?
    set_delivery
  end

  def total_price
    if self.coupon.nil?
      self.total_price = books_price.to_f + delivery_price.to_f
    else 
      self.total_price = books_price.to_f - books_price.to_f*self.coupon.sale.to_f + delivery_price.to_f
    end
  end

  def books_price
    self.order_books.inject(0){|t_p, b| t_p + b.quantity*b.price}
  end

  def sale
    if self.coupon.nil?
      0.0
    else
      self.coupon.sale
    end
  end

  def delivery_price
    if self.delivery.nil?
      0.0
    else
      self.delivery.price
    end
  end

  def sale_price
    if self.coupon.nil?
      0.0
    else
      self.coupon.sale * self.books_price
    end
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

  def coupon_attributes=(attributes)
    @coupon_number = attributes[:number]
  end

  def delivery_attributes=(attributes)
    @delivery_id = attributes[:delivery_id]
  end

  def set_coupon
    if was_setted_before? && empty_now?
      reset_coupon
    elsif coupon = find_coupon
      coupon.update(used: true, order_id: self.id)
    end
  end

  def was_setted_before?
    true if Coupon.find_by(order_id: self.id)
  end

  def empty_now?
    @coupon_number.length < 1 unless @coupon_number.nil?
  end

  def reset_coupon
    Coupon.find_by(order_id: self.id).update({used: false, order_id: nil})
  end

  def find_coupon
    Coupon.find_by(number: @coupon_number) 
  end

  def equal_shipping_address?
    @billing_equal_shipping == "1"
  end

  def set_delivery
    self.delivery_id = @delivery_id unless @delivery_id.nil?
  end

  def order_steps
    {address:       true, 
     delivery:      self.shipping_address.nil? ? false : self.shipping_address.valid? &&
                    self.billing_address.nil?  ? false : self.billing_address.valid?,
     payment:       self.delivery_id.nil?      ? false : true,
     confirm:       self.credit_card.nil?      ? false : self.credit_card.valid?}
  end

  def available_steps
    steps = [ ]
    order_steps.each{|step, passed| steps << step if passed == true}
    steps
  end
 end
