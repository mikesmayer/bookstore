require 'features/features_spec_helper'

feature "User successfully deletes book from cart"  do
  let!(:book){FactoryGirl.create(:book)}
  let(:user){FactoryGirl.create(:user, :as_customer)}

  before do
    visit new_user_session_path
    within '#new_user' do
    fill_in 'Email',     with: user.email
    fill_in 'Password',  with: user.password
    click_button("Log in")
    end
  end

  scenario 'Loginned user successfully add book to cart and create new order', js: true do
    visit shop_path
    click_link ("add_to_cart_book_#{book.id}")
    find('#cart-button').click
    click_link ("delete_book_#{book.id}")
    expect(page).not_to have_content "#{book.title}"
  end
end