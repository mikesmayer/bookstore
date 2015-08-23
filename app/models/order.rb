class Order < ActiveRecord::Base
  include AASM
  include OrderMethods
  attr_accessor :current_step,  :order_accepted, :billing_equal_shipping, :flash_notice
  belongs_to :user
  belongs_to :credit_card, autosave: true
  belongs_to :billing_address,  class_name: "Address", foreign_key: "billing_address_id", autosave: true
  belongs_to :shipping_address, class_name: "Address", foreign_key: "shipping_address_id", autosave: true
  has_many   :order_books, dependent: :destroy
  has_many   :books, through: :order_books
  has_one    :coupon
  belongs_to :delivery

  before_save do
    total_price
    set_coupon
    self.billing_address = self.shipping_address if equal_shipping_address?
    set_delivery
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

  def next_state
   states = self.aasm.states(:permitted => true).map(&:name)
   states.first
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
