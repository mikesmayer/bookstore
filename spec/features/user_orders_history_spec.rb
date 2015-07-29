require 'features/features_spec_helper'

feature "User can see history of his order"  do

  let(:order_list){FactoryGirl.create_list(:order, 5)}
 
  
  before do
    order_list.each{|o| o.user_id = order_list.first.user.id; o.save}
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email',     with: order_list.first.user.email
      fill_in 'Password',  with: order_list.first.user.password
      click_button("Log in")
    end
  end

  scenario 'Loginned user successfully sees list of his orders' do
    order_list
    visit orders_path
    expect(page).to have_content("creating", count: 5)
  end
end