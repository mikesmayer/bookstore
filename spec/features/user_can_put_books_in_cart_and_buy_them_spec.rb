require 'features/features_spec_helper'

feature "User can put book in cart and create new order"  do
  let!(:book){FactoryGirl.create(:book)}
  let!(:user){FactoryGirl.create(:user, :as_customer)}

  context "Loginned user" do

    before do
      FactoryGirl.create :country
      visit new_user_session_path
      within '#new_user' do
      fill_in 'Email',     with: user.email
      fill_in 'Password',  with: user.password
      click_button("Log in")
      end
    end

    scenario 'Loginned user successfully adds book to cart and creates new order', js: true do
      visit root_path
      find("#add_to_cart_book_#{book.id}").click
      find('#cart-button').click
      click_link ('Checkout')
      expect(page).to have_content "Shipping Address"
      expect(page).to have_content "Billing Address"
    end
  end

  context "Not loginned user" do
    scenario 'Not loginned  user redirected to login_path', js: true do
      visit root_path
      find("#add_to_cart_book_#{book.id}").click
      find('#cart-button').click
      click_link ('Checkout')
      expect(page).to have_content "LOG IN"
    end
  end
  
end