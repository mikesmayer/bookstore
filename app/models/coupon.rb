class Coupon < ActiveRecord::Base
  belongs_to :order
  validate   :coupon_active?

  def coupon_active?
    if owner_changed? && used?
     errors[:base] << "This coupon has already been used"
     #raise "#{errors.messages}"
    end
  end

  def owner_changed?
    self.order_id != Coupon.find_by(number: self.number).order_id unless self.order_id.nil?
    #raise "#{self.order_id} #{Coupon.find_by(number: self.number).order_id} #{self.order_id != Coupon.find_by(number: self.number).order_id} "
  end

  def used?
    Coupon.find_by(number: self.number).used == true
  end
end
