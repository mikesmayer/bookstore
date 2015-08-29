class Order < ActiveRecord::Base
  include AASM
  include OrderMethods
  include StateMachineMethods
  attr_accessor :current_step, :order_accepted, :flash_notice
  belongs_to :user
  belongs_to :credit_card, autosave: true
  belongs_to :billing_address,  class_name: "Address", autosave: true
  belongs_to :shipping_address, class_name: "Address", autosave: true
  has_many   :order_books, dependent: :destroy
  has_many   :books, through: :order_books
  has_one    :coupon
  belongs_to :delivery

  before_save do
    total_price
    set_coupon
  end

  def order_books_attributes=(attributes)
    self.order_books.map do |order_book| 
      order_book.update_attributes(attributes["#{self.order_books.index(order_book)}"])
    end
  end

  def total_price
    if self.coupon.nil?
      self.total_price = (books_price.to_f + delivery_price.to_f).round(2)
    else 
      self.total_price = (books_price.to_f - books_price.to_f*self.coupon.sale.to_f + delivery_price.to_f).round(2)
    end
  end

  def set_coupon
    if was_setted_before? && empty_now?
      reset_coupon
      @flash_notice = I18n.t("success.notices.coupon_deactivate")
    elsif coupon = find_coupon
      coupon.update(used: true, order_id: self.id)
      @flash_notice = I18n.t("success.notices.coupon_activate")
    end
  end

  def add_book(book, quantity = 1)
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
end
