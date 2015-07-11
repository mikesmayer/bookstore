require 'features/features_spec_helper'

feature "A user can search for books by author, title"  do
  let(:first_book){FactoryGirl.create(:book)}
  let(:second_book){FactoryGirl.create(:book)}
  
  scenario 'User successfully search book by title', js: true do
    first_book
    second_book
    visit books_path
    expect(page).to have_content "#{second_book.title}"
    fill_in 'Search',        with: "#{first_book.title}"
    expect(page).to have_content "#{first_book.title}"
    expect(page).not_to have_content "#{second_book.title}"
  end

  scenario 'User successfully search book by author', js: true  do
    visit books_path
    first_book
    second_book
    fill_in 'Search',        with: "#{first_book.author.first_name}"
    expect(page).to have_content "#{first_book.title}"
    expect(page).not_to have_content "#{second_book.title}"
  end
end