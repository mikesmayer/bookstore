module BooksHelper
  def users_list(book)
    render partial: "users/user_wisher",  collection: book.users, as: :user
  end

  def book_reviews(book)
    Review.all.where(approved: true, book_id: book.id)
  end

  def cart_total_price
    if cart_order.class != Order
      price = 0.0
    else
      price = cart_order.order_books.inject(0){|price, o_b| price + o_b.price*o_b.quantity}
    end
  end

  def cart_books_quantity
    if cart_order.class != Order
      quantity = 0.0
    else
      quantity = cart_order.order_books.inject(0){|quantity, o_b| quantity + o_b.quantity}
    end
  end
end
