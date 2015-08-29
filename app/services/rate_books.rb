class RateBooks
  include Service

  def initialize
    @top_books_ids = OrderBook.group(:book_id).count.sort_by{|k, v| v}.last(3).map!(&:first)
  end

  def call
    @top_books = Book.find(@top_books_ids)
  end
end