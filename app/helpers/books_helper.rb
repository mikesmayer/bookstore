module BooksHelper
  # def cart_preview
  #   render partial: "books/cart_preview"
  # end

  # def cart_books_list
  #   render partial: "books/cart_books_list"
  # end

  def users_list(book)
    render partial: "users/user_wisher",  collection: book.users, as: :user
  end

  def book_reviews(book)
    Review.all.where(approved: true, book_id: book.id)
  end
end
