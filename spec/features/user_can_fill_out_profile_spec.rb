require 'features/features_spec_helper'

feature 'User has one profile with contact info' do
  let(:profile){FactoryGirl.create :profile}
  let(:billing_address){FactoryGirl.create :address}
  let(:shipping_address){FactoryGirl.create :address}
  let(:credit_card){FactoryGirl.create :credit_card}

  before do
    visit new_user_session_path
    within '#new_user' do
    fill_in 'Email',     with: profile.user.email
    fill_in 'Password',  with: profile.user.password
    click_button("Log in")
    end
  end

  scenario 'After registering user has his own profile ' do
    visit profile_path
    click_link "Edit"
    
    
    #shipping address
    within "#shipping_address" do
      fill_in 'User address',     with: shipping_address.user_address
      fill_in 'Zipcode',          with: shipping_address.zipcode
      fill_in 'City',             with: shipping_address.city
      fill_in 'Phone',            with: shipping_address.phone
      fill_in 'Country',          with: shipping_address.country.name
    end

    #billing address
    within "#billing_address" do
      fill_in 'User address',     with: billing_address.user_address
      fill_in 'Zipcode',          with: billing_address.zipcode
      fill_in 'City',             with: billing_address.city
      fill_in 'Phone',            with: billing_address.phone
      fill_in 'Country',          with: billing_address.country.name
    end

    #credit card
    within "#credit_card" do
      fill_in 'Number',           with: credit_card.number
      fill_in "Cvv",              with: credit_card.cvv
      fill_in "Expiration month", with: credit_card.expiration_month
      fill_in "Expiration year",  with: credit_card.expiration_year
      fill_in "First name",       with: credit_card.first_name
      fill_in "Last name",        with: credit_card.last_name
    end

    click_button("Update Profile")
  
    expect(page).to have_content(shipping_address.user_address)
    expect(page).to have_content(billing_address.user_address)
    expect(page).to have_content(credit_card.number)
  end
end