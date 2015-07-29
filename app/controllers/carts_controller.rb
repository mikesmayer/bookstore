class CartsController < ApplicationController
  before_action :current_cart
  before_action :set_book, except: :show

  def delete_from_cart
    @cart.delete_book(@book)
    
    respond_to do |format|
      format.js
    end
  end

  def add_to_cart
    @cart.add_book(@book)
    
    respond_to do |format|
      format.js
    end
  end

  def show
    
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end
end
