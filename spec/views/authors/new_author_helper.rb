RSpec.shared_examples "a new_author_form" do

  let (:author){mock_model("Author").as_new_record}

  before do
    allow(author).to receive_messages( first_name: nil,
                                       last_name: nil, 
                                       biography: nil)
    assign(:author, author)
    render
  end

  it "has new_author form" do 
    expect(rendered).to have_selector('form#new_author')
  end

  it "has author_first_name field" do
    expect(rendered).to have_selector('#author_first_name')
  end

  it "has author_last_name field" do
    expect(rendered).to have_selector('#author_last_name')
  end

  it "has author_biography field" do
    expect(rendered).to have_selector('#author_biography')
  end

  it "has submit button" do
    expect(rendered).to have_selector('input[type="submit"]')
  end

  it "has link to authors_path" do
    expect(rendered).to have_link('Back', href: authors_path)
  end

end



