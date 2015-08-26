module OrderMethods

  extend ActiveSupport::Concern

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

  def quantity_in_order(book)
    self.order_books.find_by(book_id: book.id).quantity
  end

  def order_book_params(book, quantity)
    {order_id: self.id, book_id: book.id, quantity: 1, price: book.price}
  end

  def coupon_attributes=(attributes)
    @coupon_number = attributes[:number]
  end

  def delivery_attributes=(attributes)
    @delivery_id = attributes[:delivery_id]
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
end