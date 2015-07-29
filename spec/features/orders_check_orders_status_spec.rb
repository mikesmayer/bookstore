require 'features/features_spec_helper'

feature "User check status his orders"  do

  let(:user){FactoryGirl.create :user, :as_customer}
  let(:order){FactoryGirl.create(:order, user_id: user.id)}
 
  
  before do
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email',     with: user.email
      fill_in 'Password',  with: user.password
      click_button("Log in")
    end
  end

  scenario 'Loginned user successfully checks order status' do
    order
    visit '/orders'
    expect(page).to have_content "creating"
  end
end