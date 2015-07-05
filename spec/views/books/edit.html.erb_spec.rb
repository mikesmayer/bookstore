require 'rails_helper'
require 'views/books/new_book_helper'

RSpec.describe "books/edit", type: :view do
  it_behaves_like "a new_book_form"
end
