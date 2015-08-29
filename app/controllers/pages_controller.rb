class PagesController < ApplicationController
  def home
    @top_books = RateBooks.call
  end
end
