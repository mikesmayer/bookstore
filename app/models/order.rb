class Order < ActiveRecord::Base
  include AASM
  include OrderMethods
  attr_accessor :current_step,  :order_accepted, :billing_equal_shipping, :flash_notice
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
  validates :shipping_address, :billing_address, :credit_card, presence: true,  if: :last_step?

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

  def set_coupon
    if was_setted_before? && empty_now?
      reset_coupon
      @flash_notice = "Coupon was disactivated"
    elsif coupon = find_coupon
      coupon.update(used: true, order_id: self.id)
      @flash_notice = "Coupon was activated"
    end
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
