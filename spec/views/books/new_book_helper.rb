
RSpec.shared_examples "a new_book_form" do

  
  #let(:filterrific){mock_model("TestFilterrific")}
  # let(:valid_attributes){FactoryGirl.attributes_for(:book)}
  # let(:book){mock_model(Book, valid_attributes)}

  before do

    # allow(book).to receive_messages( title: nil,
    #                                  description: nil,
    #                                  price: nil, 
    #                                  quantity: nil
    #                                  #first_name:   nil,
    #                                   )
    # allow(filterrific).to receive(:search_query)
    # assign(:filterrific, filterrific)
    assign(:book, book)
    render
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

  it "has select author field" do
    expect(rendered).to have_selector('select#book_author_id')
  end

  it "has select category field" do
    expect(rendered).to have_selector('select#book_category_id')
  end

  it "has save button" do
    expect(rendered).to have_selector('input[type="submit"]')
  end

  it "has link to books_path" do
    expect(rendered).to have_link('Back', href: books_path)
  end
end