module CartsHelper
  # def cart_books
  #   session["cart"]["books"]
  # end

  # def cart_total_price
  #   price = cart_books.inject(0){|price, book| price + book["price"].to_f*book["quantity"].to_i}
  #   price
  # end

  # def cart_books_quantity
  #   quantity = cart_books.inject(0){|quantity, book| quantity + book["quantity"].to_i}
  #   quantity
  # end

  # def find_book(id)
  #   Book.find(id)
  # end

  def errors_builder(errors, errors_for = {})
    order_book_id = errors_for[:order_book]
    if errors != nil
      return errors["order_books.#{order_book_id}"].first unless errors["order_books.#{order_book_id}"].nil?
      return errors["order_books.#{order_book_id}"].first unless errors["order_books.#{order_book_id}"].nil?  
    end
  end

end
