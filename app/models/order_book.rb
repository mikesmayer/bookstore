class OrderBook < ActiveRecord::Base
  belongs_to :book
  belongs_to :order
  validates_numericality_of :quantity, 
                          greater_than_or_equal_to: 1
  validate :book_quantity, if: :increase_book_quantity?

  def increase_book_quantity?
    if self.new_record?
      true
    else 
      OrderBook.find(self.id).quantity < self.quantity
    end
  end

  def book_quantity
    unless self.book.book_in_stock(self.quantity)
      self.errors.add("#{self.id}".to_sym, self.book.errors.messages[:book_quantity_error].first)
    end
  end


  # after_destroy do
  #   self.book.update_book(:increase, self.quantity )
  # end

  # before_save do
  #   if self.order.confirmation?
  #     build_operation
  #     self.book.update_book(@operation, change_book_quantity)
  #   end
  # end

  # def build_operation
  #   if increase_book_quantity?
  #     @operation = :reduce
  #   else
  #     @operation = :increase
  #   end
  # end

  # def change_book_quantity
  #   if self.new_record?
  #     self.quantity
  #   else
  #     (self.quantity - OrderBook.find(self.id).quantity).abs
  #   end
  # end
end
