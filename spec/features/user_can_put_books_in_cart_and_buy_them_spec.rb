require 'features/features_spec_helper'

feature "User can put book in cart and create new order"  do
  let(:book){FactoryGirl.create(:book)}
  let(:user){FactoryGirl.create(:user)}

  context "Loginned user" do

    before do
      visit new_user_session_path
      within '#new_user' do
      fill_in 'Email',     with: user.email
      fill_in 'Password',  with: user.password
      click_button("Log in")
      end
    end

    scenario 'Loginned user successfully adds book to cart and creates new order', js: true do
      book
      visit root_path
      click_link ('Add to cart')
      click_link ('Create Order')
      expect(page).to have_content "New Order"
      expect(page).to have_content "#{book.title}"
      expect(page).to have_content "#{book.price}"
      expect(page).to have_content "#{book.author.full_name}"
    end
  end

 context "Not loginned user" do
   scenario 'Not loginned  user redirected to login_path', js: true do
     book
     visit root_path
     click_link ('Add to cart')
     click_link ('Create Order')
     expect(page).to have_content "You should log in for creating order"
   end
 end
  
end