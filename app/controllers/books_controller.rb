class BooksController < ApplicationController
  include FilterrificStuff
  before_action :add_temp_order, :set_order
  load_and_authorize_resource :book

  def index
    #reset_session
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
  end

  def edit
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, status: 302, notice: 'Book was successfully created.'
    else
      render :new
    end
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_url, notice: 'Book was successfully destroyed.'
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
      end
    end
  end

  def delete_from_wish_list
    if current_user
      current_user.books.destroy(@book) if current_user.books.include?(@book)
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def add_temp_order
    if current_user && Order.find_by(user_id: current_user, status: "in_progress").nil?
      Order.create(user_id: current_user.id)
    elsif session["order_id"].nil?
      session["order_id"] = Order.create.id
    end
  end

  def set_order
    if current_user
      @order = Order.where(user_id: current_user.id, status: "in_progress").last
    else
      @order = Order.find_by(id: session["order_id"])
    end
  end

  def book_params
   params.require(:book).permit(:id,:title, :description, :price, :quantity, 
                                :filterrific, :author_id, :category_id, :cover, :remote_cover_url)
  end
end


