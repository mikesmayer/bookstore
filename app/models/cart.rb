class Cart

  include BookSearch

  attr_reader :books

  def initialize(session)
    @session = session
    check_cart
  end

  def add_book(book)
    if book_in_cart(book)
      book_in_cart(book)["quantity"] +=1
    else
      @session["cart"]["books"] << book_to_hash(book.id)
    end
  end

  def delete_book(book)
    if book_in_cart(book)["quantity"] == 1
      @session["cart"]["books"].delete(@session["cart"]["books"].find{|b| b["id"] == book.id})
    else
      book_in_cart(book)["quantity"] -= 1
    end
  end

  def book_in_cart(book)
    if @session["cart"]["books"] == []
      false
    else
      @session["cart"]["books"].find{|b| b["id"] == book.id}
    end
  end

  def total_price
    price = @session["cart"]["books"].inject(0){|p, b| p + b["price"].to_f*b["quantity"].to_i}
    price
  end

  private

  def check_cart
    @session["cart"] = {"books" => []} if @session["cart"].nil?
  end
end