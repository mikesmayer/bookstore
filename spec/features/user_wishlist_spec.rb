require 'features/features_spec_helper'

feature "User can add book to wishlist"  do
  let(:book){FactoryGirl.create(:book)}
  let(:user){FactoryGirl.create(:user, :as_customer)}

  before do
    visit new_user_session_path
    within '#new_user' do
    fill_in 'Email',     with: user.email
    fill_in 'Password',  with: user.password
    click_button("Log in")
    end
  end

  scenario 'Loginned user successfully add book to wishlist that can see other users', js: true do
    book
    visit book_path(book)
    click_link ('Wish')
    click_link "Sign out"
    visit book_path(book)
    expect(page).to have_content "#{user.email.split('@').first}"
  end
end