require 'rails_helper'

RSpec.shared_examples "all user" do

  it "has rendered books contents" do
    expect(view).to render_template('_book', count: 2)
  end
  
  it "has content 'Listing Books'" do
    expect(rendered).to match /Listing Books/
  end

  it "has link to show_book_path" do
    expect(rendered).to have_link('Show', href: book_path(book))
  end
end

RSpec.shared_examples "visitors" do
  it "doesn't have link to edit_book_path" do
    expect(rendered).not_to have_link('Edit')
  end

end

RSpec.shared_examples "customers" do
  
end

RSpec.describe "books/index", type: :view do
  let (:book_params){FactoryGirl.attributes_for :book}
  let (:book){stub_model(Book, book_params)}
  let (:author){FactoryGirl.build :author}
  let (:category){FactoryGirl.build :category}
  
  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    allow(view).to receive(:form_for_filterrific)
    allow(book).to receive(:author).and_return(author)
    allow(book).to receive(:category).and_return(category)
  end

  context "visitor" do
    before do
      assign(:books, [book, book])
      render
    end

    it_behaves_like "all user"
    it_behaves_like "visitors"
  end

  context "customers" do
    before do
      assign(:books, [book, book])
      render
    end

    it_behaves_like "all user"
    it_behaves_like "visitors"
    it_behaves_like "customers"
  end

  context "admin" do
    before do
      @ability.can :manage, :book
      assign(:books, [book, book])
      render
    end

    it_behaves_like "all user"
  
    it "has link to new_book_path" do
      expect(rendered).to have_link('New Book')
    end

    it "has link to edit_book_path" do
      expect(rendered).to have_link('Edit', href: edit_book_path(book))
    end

    it "has link to destroy_book_path" do
      expect(rendered).to have_link('Destroy', href: book_path(book))
    end
  end
end
