class BooksController < ApplicationController

  include FilterrificStuf

  before_action :add_cart
  load_and_authorize_resource



  def index  
    #session["cart"]["books"] = []
    filterrific_books
    if @filterrific.nil?
      @books = Book.all
    else
      @books = Book.filterrific_find(@filterrific).paginate(:page => params[:page])
    end
  end

  def show
    @review = Review.new(book_id: @book.id)
  end

  def new
    @book = Book.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
  end

  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, status: 302, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        flash.now[:error] = 'Could not save book.'
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_to_cart
    if book_in_cart
      book_in_cart["quantity"] +=1
    else
      session["cart"]["books"] << book_to_hash
    end

    respond_to do |format|
      format.html{render :nothing, true}
      format.js
    end
  end

  def add_to_wish_list
    if current_user
      current_user.books << @book unless current_user.books.include?(@book)
    end

    respond_to do |format|
      if current_user
        format.html { }
        format.js
      else
        format.html {redirect_to new_user_session_path, 
                     notice: 'You should log in for creating order' unless current_user}
      end
    end
  end

  def delete_from_wish_list
    if current_user
      current_user.books.destroy(@book) if current_user.books.include?(@book)
    end

    respond_to do |format|
      format.html { }
      format.js
    end
  end


  def cart
    
  end

  def delete_from_cart
    if book_in_cart["quantity"] == 1
      session["cart"]["books"].delete(session["cart"]["books"].find{|book| book["id"] == "#{params[:id]}".to_i})
    else
      book_in_cart["quantity"] -= 1
    end

    respond_to do |format|
       #format.html
       format.js
     end
  end

  def add_cart
      if session["cart"].nil?
        session["cart"] = {"books" => []}
      end
    end

  private

    def book_in_cart
      if session["cart"]["books"] == []
        false
      else
        session["cart"]["books"].find{|book| book["id"] == "#{params[:id]}".to_i}
      end
    end

    def set_book
      @book = Book.find(params[:id])
    end

    def book_to_hash
      book = Book.find(params[:id])
      book_hash =  { "id" => book.id,
                     "author"=>book.author.full_name,
                     "title"=> book.title,
                     "price"=> book.price,
                     "quantity" => 1
                     }
      book_hash
    end

    def total_price
     price = session["cart"]["books"].inject(0){|p, b| p + b["price"].to_f*b["quantity"].to_i}
     price
    end

    def book_params
     params.require(:book).permit(:id,:title, :description, :price, :quantity, 
                                  :filterrific, :author_id, :category_id, :cover, :remote_cover_url)
    end
end


