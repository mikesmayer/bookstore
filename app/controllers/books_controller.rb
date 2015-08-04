class BooksController < ApplicationController
  include FilterrificStuff
  before_action :add_temp_order, only: :add_to_cart
  load_and_authorize_resource 

  def index 
    #session["temp_order"] = nil 
    filterrific_books
    if @filterrific.nil?
      @books = Book.all
    else
      @books = Book.filterrific_find(@filterrific).paginate(:page => params[:page]).accessible_by(current_ability)
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

  def add_to_wish_list
    if current_user
      current_user.books << @book unless current_user.books.include?(@book)
    end

    respond_to do |format|
      if current_user
        format.html
        format.js
      else
        format.html 
        #format.js
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

  def add_to_cart
    @order = Order.as_cart(session['temp_order'])
    # render text: "#{@order.add_book(@book, 1)}"
    respond_to do |format|
      if @order.add_book(@book, 1)
        format.js
      else 
        flash[:notice] = @book.errors
        format.js
      end
    end
  end

  def delete_from_cart
    @order = Order.as_cart(session['temp_order'])
    @order.delete_book(@book)
    redirect_to :back
  end

  private

  def add_temp_order 
    if current_user && session["temp_order"].nil?
      Order.create(user_id: current_user.id, session_id: session["session_id"])
    elsif session["temp_order"].nil?
      Order.create(session_id: session["session_id"])
    end
    session["temp_order"] = session["session_id"] unless session["temp_order"]
  end

    def book_params
     params.require(:book).permit(:id,:title, :description, :price, :quantity, 
                                  :filterrific, :author_id, :category_id, :cover, :remote_cover_url)
    end
end


