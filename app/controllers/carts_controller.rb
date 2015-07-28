class CartsController < ApplicationController
  before_action :current_cart
  before_action :set_book, except: :show
  respond_to :html, :js

  def delete_from_cart
    @cart.delete_book(@book)
    respond_with(@cart, status: 200)
  end

  def add_to_cart
    @cart.add_book(@book)
    respond_with(@cart, status: 200)
  end

  def show
    
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end
end
