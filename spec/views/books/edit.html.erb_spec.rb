require 'rails_helper'
require 'views/books/new_book_helper'

RSpec.describe "books/edit", type: :view do
  
  let(:valid_attributes){FactoryGirl.attributes_for(:book)}
  let(:book){mock_model(Book, valid_attributes)}

  before do
    assign(:book, book)
    render
  end

  it "has edit_book form" do 
    expect(rendered).to have_selector("form#edit_book_#{book.id}")
  end

  it_behaves_like "a new_book_form"
end
