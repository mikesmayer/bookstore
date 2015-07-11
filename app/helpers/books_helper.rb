module BooksHelper

  def cart
    
  end

  def cart_books
    session["cart"]["books"]
  end

  def cart_total_price
    price = cart_books.inject(0){|price, book| price + book["price"].to_f}
    price
  end

  def cart_books_list
    render partial: "cart", locals: {cart_books: cart_books}
  end
end
