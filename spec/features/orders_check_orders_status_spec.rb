require 'features/features_spec_helper'

feature "User check status his orders" do

  let(:user){FactoryGirl.create  :user, :as_customer}
  let!(:book){FactoryGirl.create :book}
 
  before do
    visit root_path
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email',     with: user.email
      fill_in 'Password',  with: user.password
      click_button("Log in")
    end
    user.orders.last.add_book(book, 1)
  end

  scenario 'Loginned user successfully checks order status' do
    visit '/orders'
    expect(page).to have_content "#{user.orders.last.books.first.title}"
    expect(page).to have_content "IN PROGRESS"
  end
end