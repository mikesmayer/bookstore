require 'features/features_spec_helper'

feature "User check status his orders"  do

  let(:order){FactoryGirl.create(:order)}
 
  
  before do
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email',     with: order.user.email
      fill_in 'Password',  with: order.user.password
      click_button("Log in")
    end
  end

  scenario 'Loginned user successfully checks order status' do
    order
    visit orders_path
    expect(page).to have_content "processed"
  end
end