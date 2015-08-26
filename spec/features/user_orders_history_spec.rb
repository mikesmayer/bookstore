require 'features/features_spec_helper'

feature "User can see history of his order"  do

  let!(:book){FactoryGirl.create :book}
  let(:user){FactoryGirl.create :user, :as_customer}
  let!(:order){FactoryGirl.create :order, user_id: user.id}
 
  before do
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email',     with: user.email
      fill_in 'Password',  with: user.password
      click_button("Log in")
    end
    visit root_path
    find("#add_to_cart_book_#{book.id}").click
  end

  scenario 'Loginned user successfully sees his cart', js: true do
    visit orders_path
    expect(page).not_to have_content("Your cart is empty.")
  end

  scenario 'Loginned user successfully sees his in_process orders', js: true do
    order.set_in_process!
    visit orders_path
    expect(page).not_to have_content("Your cart is empty.")
    expect(page).to have_content("in_process")
  end
end