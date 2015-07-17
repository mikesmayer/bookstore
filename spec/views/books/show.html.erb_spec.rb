require 'rails_helper'

shared_examples "all user show_book" do

  it "has book_title content" do
    expect(rendered).to have_content(book.title)
  end

  it "has book_author_full_name content" do
    expect(rendered).to have_content(book.author.full_name)
  end

  it "has book_category content" do
    expect(rendered).to have_content(book.category.category_name)
  end

  it "has book_description content" do
    expect(rendered).to have_content(book.description)
  end

  it "has book_price content" do
    expect(rendered).to have_content(book.price)
  end

  it "has book_quantity content" do
    expect(rendered).to have_content(book.quantity)
  end

  it "has link to books_path" do
    expect(rendered).to have_link('Back', href: root_path)
  end
end

RSpec.describe "books/show", type: :view do
  let (:book){FactoryGirl.create(:book)}

  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
  end


  context "all users" do
    before do
      assign(:book, book)
      render
    end

    it_behaves_like "all user show_book"

    it "doesn't have link to edit_book_path" do
      expect(rendered).not_to have_link('Edit')
    end
  end

  context "admin" do
    before do
      @ability.can :manage, :book
      assign(:book, book)
      render
    end
    
    it_behaves_like "all user show_book"

    it "has link to edit_book_path" do
      expect(rendered).to have_link('Edit')
    end
  end
end

