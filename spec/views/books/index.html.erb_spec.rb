require 'rails_helper'

RSpec.describe "books/index", type: :view do
  let (:book_params){{ title: "Title",
                       description: nil, 
                       price: nil, 
                       quantity: nil }}
  let (:book){stub_model(Book, book_params)}
  
  before do
    assign(:books, [book, book])
    render
  end

  it "has book_title contents" do
    expect(view).to render_template('_book', count: 2)
  end

  it "has context content 'Listing Books'" do
    expect(rendered).to match /Listing Books/
  end

  it "has link to new_book_path" do
    expect(rendered).to have_link('New Book')
  end

  
end
