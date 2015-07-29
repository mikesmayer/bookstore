require 'features/features_spec_helper'

feature "A user can search for books by author, title"  do
  let!(:first_book){FactoryGirl.create(:book)}
  let!(:second_book){FactoryGirl.create(:book)}
  
  scenario 'User successfully search book by title', js: true do
    visit books_path
    Capybara.ignore_hidden_elements = false
    expect(page).to have_content "#{second_book.title}"
    fill_in 'Search',        with: "#{first_book.title}"
    expect(page).to have_content "#{first_book.title}"
    expect(page).not_to have_content "#{second_book.title}"
    Capybara.ignore_hidden_elements = true
  end

  scenario 'User successfully search book by author', js: true  do
    visit books_path
    fill_in 'Search',        with: "#{first_book.author.first_name}"
    Capybara.ignore_hidden_elements = false
    expect(page).to have_content "#{first_book.title}"
    expect(page).not_to have_content "#{second_book.title}"
    Capybara.ignore_hidden_elements = true
  end
end