require 'features/features_spec_helper'

feature "A user can navigate the site by categories"  do
  let(:first_book){FactoryGirl.create(:book)}
  let(:second_book){FactoryGirl.create(:book)}

  scenario 'User successfully navigate book by category', js: true do
    first_book
    second_book
    visit books_path
    find('.select-dropdown').click
    find('span', text: "#{first_book.category.category_name}").click
    expect(page).not_to have_content "#{second_book.title}"
    expect(page).to have_content "#{first_book.title}"
  end
end