module BooksHelper
  def cart_books
    session["cart"]["books"]
  end

  def cart_total_price
    price = cart_books.inject(0){|price, book| price + book["price"].to_f*book["quantity"].to_i}
    price
  end

  def cart_books_quantity
    quantity = cart_books.inject(0){|quantity, book| quantity + book["quantity"].to_i}
    quantity
  end

  def cart_preview
    render partial: "books/cart_preview"
  end

  def cart_books_list
    render partial: "books/cart_books_list"
  end

  def users_list(book)
    render partial: "users/user_wisher",  collection: book.users, as: :user
  end

  def book_reviews(book)
    Book.find(book.id).reviews.where(approved: true)
  end
end
