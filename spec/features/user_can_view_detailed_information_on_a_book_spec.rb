require 'features/features_spec_helper'

feature "A user can view detailed information on a book"  do
  let(:book){FactoryGirl.create(:book)}
  
  scenario 'User successfully views detailed information on a book', js: true do
    book
    visit root_path
    click_link ('Show')
    expect(page).to have_content "#{book.title}"
    expect(page).to have_content "#{book.description}"
    expect(page).to have_content "#{book.price}"
    expect(page).to have_content "#{book.author.full_name}"
    expect(page).to have_content "#{book.category.category_name}"
  end
end