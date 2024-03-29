require 'features/features_spec_helper'

feature "A user can view detailed information on a book"  do
  let(:book){FactoryGirl.create(:book)}
  
  scenario 'User successfully views detailed information on a book' do
    book
    visit book_path(book)
    expect(page).to have_content "#{book.title}"
    expect(page).to have_content "#{book.description}"
    expect(page).to have_content "#{book.price}"
    expect(page).to have_content "#{book.author.full_name}"
  end
end