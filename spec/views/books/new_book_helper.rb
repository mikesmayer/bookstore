
RSpec.shared_examples "a new_book_form" do

  let (:book){mock_model("Book").as_new_record}

  before do
    allow(book).to receive_messages( title: nil,
                                     description: nil, 
                                     price: nil, 
                                     quantity: nil )
    assign(:book, book)
    render
  end

  it "has new_book form" do 
    expect(rendered).to have_selector('form#new_book')
  end

  it "has book_title field" do
    expect(rendered).to have_selector('#book_title')
  end

  it "has book_description field" do
    expect(rendered).to have_selector('#book_description')
  end

  it "has book_price field" do
    expect(rendered).to have_selector('#book_price')
  end

  it "has book_quantity field" do
    expect(rendered).to have_selector('#book_quantity')
  end

  it "has register button" do
    expect(rendered).to have_selector('input[type="submit"]')
  end

  it "has link to books_path" do
    expect(rendered).to have_link('Back', href: books_path)
  end
end