class Cart

  attr_reader :books

  def initialize(session)
    @session = session
    #@books = books_in_cart(session)
  end

  def books_in_cart
    @session["cart"]["books"]
  end

  def add_book
    @session["cart"]["books"] << "tester"
  end
  def hello
    "hello"
  end
  
end