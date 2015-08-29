class BooksController < ApplicationController
  include FilterrificStuff
  load_and_authorize_resource :book

  def index
    filterrific_books
    if @filterrific.nil?
      @books = Book.accessible_by(current_ability).all
    else
      @books = Book.filterrific_find(@filterrific).paginate(:page => params[:page]).accessible_by(current_ability)
    end
  end

  def show
    @review = Review.new(book_id: @book.id)
  end

  def new
  end

  def edit
  end

  def create
    if @book.save(book_params)
      redirect_to @book, notice: t("success.notices.create", resource: "Book")
    else
      render :new
    end
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: t("success.notices.update", resource: "Book")
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: t("success.notices.destroy", resource: "Book")
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

  def book_params
    params.require(:book).permit(:id,:title, :description, :price, :quantity, 
                                :filterrific, :author_id, :category_id, :cover, :remote_cover_url)
  end
end


