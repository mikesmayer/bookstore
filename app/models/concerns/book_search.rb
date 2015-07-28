module BookSearch

  extend ActiveSupport::Concern

  def book_to_hash(book_id)
    book = Book.find(book_id)
    book_hash =  { "id" => book.id,
                   "author"=>book.author.full_name,
                   "title"=> book.title,
                   "price"=> book.price,
                   "quantity" => 1
                   }
    book_hash
  end
end