require 'features/features_spec_helper'

feature 'Order creating process' do

  let(:user){FactoryGirl.create :user}
  let(:book){FactoryGirl.create :book}
  let(:shippin_address){FactoryGirl.create :address}
  let(:billing_address){FactoryGirl.create :address}
  let(:credit_card){FactoryGirl.create :credit_card}

  before do
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email',     with: user.email
      fill_in 'Password',  with: user.password
      click_button("Log in")
    end
    visit root_path
    click_link 'Add to Cart'
    click_link 'Create Order'
  end
  
  scenario 'User successfully fills out shipping address form' do
    
  end
end