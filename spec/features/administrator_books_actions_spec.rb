require 'features/features_spec_helper'

feature "Books management" do

  let(:new_book){FactoryGirl.build(:book)}
  let(:existins_book){FactoryGirl.build(:book)}
  let(:user_admin){FactoryGirl.create(:user,:as_admin)}

  before do

    visit new_user_session_path

    within '#new_user' do
      fill_in 'Email',     with: user_admin.email
      fill_in 'Password',  with: user_admin.password
      click_button("Log in")
    end
    
    visit new_book_path

  end

  scenario "Administrator successfully creates new book" do

    within '#new_book' do
      fill_in 'Title',        with: new_book.title
      fill_in 'Description',  with: new_book.description
      fill_in 'Price',        with: new_book.price
      fill_in 'Quantity',     with: new_book.quantity
      click_button("Add book")
    end

    expect(page).to have_content "#{book.title}"
    expect(page).to have_content "#{book.description}"
    expect(page).to have_content "#{book.price}"
    expect(page).to have_content "#{book.quantity}"

  end

end