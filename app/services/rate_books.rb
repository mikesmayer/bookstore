class RateBooks
  include Service
  include ActiveModel::Model

  def initialize
    @top_books_ids = OrderBook.top_books.map!(&:book_id)
  end

  def call
    @top_books = Book.find(@top_books_ids)
  end
end