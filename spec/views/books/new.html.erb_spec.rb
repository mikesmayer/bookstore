require 'rails_helper'
require 'views/books/new_book_helper'

RSpec.describe "books/new", type: :view do
  
  let(:valid_attributes){FactoryGirl.attributes_for(:book)}
  let(:book){mock_model(Book, valid_attributes).as_new_record}

  before do
    assign(:book, book)
    render
  end

  it "has new_book form" do 
    expect(rendered).to have_selector('form#new_book')
  end

  it_behaves_like "a new_book_form"
end



