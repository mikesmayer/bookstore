
RSpec.shared_examples "a new_category_form" do

  let (:category){mock_model("Category").as_new_record}

  before do
    allow(category).to receive_messages(category_name: nil)
    assign(:category, category)
    render
  end

  it "has new_category form" do 
    expect(rendered).to have_selector('form#new_category')
  end

  it "has category_category_name field" do
    expect(rendered).to have_selector('#category_category_name')
  end

  it "has save button" do
    expect(rendered).to have_selector('input[type="submit"]')
  end

  it "has link to categories_path" do
    expect(rendered).to have_link('Back', href: categories_path)
  end
end