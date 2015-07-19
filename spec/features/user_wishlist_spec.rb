require 'features/features_spec_helper'

feature "User can add book to wishlist"  do
  let(:book){FactoryGirl.create(:book)}
  let(:user){FactoryGirl.create(:user)}

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
    visit root_path
    click_link ('Wish')
    click_link "Sign out"
    click_link ('Show')
    expect(page).to have_content "#{user.email}"
  end
end