require 'features/features_spec_helper'

feature 'Order creating process', js: true do

  let(:user){FactoryGirl.create :user}
  let(:book){FactoryGirl.create :book}
  let(:shipping_address){FactoryGirl.create :address}
  let(:billing_address){FactoryGirl.create :address}
  let(:credit_card){FactoryGirl.create :credit_card}

  before do
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email',     with: user.email
      fill_in 'Password',  with: user.password
      click_button("Log in")
    end
    book
    visit root_path
    click_link 'Add to cart'
    click_link 'Create Order'

    #shipping address step
    within '#new_order' do
      fill_in "User address", with: shipping_address.user_address
      fill_in "Zipcode",      with: shipping_address.zipcode
      fill_in "City",         with: shipping_address.city
      fill_in "Phone",        with: shipping_address.phone
      fill_in "Country",      with: shipping_address.country.name
      click_button "Continue"
    end

    # billing_address_step
    within '#new_order' do
      fill_in "User address", with: billing_address.user_address
      fill_in "Zipcode",      with: billing_address.zipcode
      fill_in "City",         with: billing_address.city
      fill_in "Phone",        with: billing_address.phone
      fill_in "Country",      with: billing_address.country.name
      click_button "Continue"
    end

    # credit_card step
    within '#new_order' do
      fill_in "Number",           with: credit_card.number
      fill_in "Cvv",              with: credit_card.cvv
      fill_in "Expiration month", with: credit_card.expiration_month
      fill_in "Expiration year",  with: credit_card.expiration_year
      fill_in "First name",       with: credit_card.first_name
      fill_in "Last name",        with: credit_card.last_name
      click_button "Continue"
    end
  end
  
  scenario 'User successfully fills out shipping address form'  do
    expect(page).to have_content("Shipping Address")
    expect(page).to have_content("#{shipping_address.user_address}")
    expect(page).to have_content("#{shipping_address.zipcode}")
    expect(page).to have_content("#{shipping_address.phone}")
    expect(page).to have_content("#{shipping_address.city}")
    expect(page).to have_content("#{shipping_address.country.name}")
  end

  scenario 'User successfully fills out billing address form'  do
    expect(page).to have_content("Billing Address")
    expect(page).to have_content("#{billing_address.user_address}")
    expect(page).to have_content("#{billing_address.zipcode}")
    expect(page).to have_content("#{billing_address.phone}")
    expect(page).to have_content("#{billing_address.city}")
    expect(page).to have_content("#{billing_address.country.name}")
  end

  scenario 'User successfully fills out credit_card form' do
    expect(page).to have_content("Credit Card")
    expect(page).to have_content("#{credit_card.number}")
    expect(page).to have_content("#{credit_card.cvv}")
    expect(page).to have_content("#{credit_card.expiration_month}")
    expect(page).to have_content("#{credit_card.credit_card.expiration_year}")
    expect(page).to have_content("#{credit_card.first_name}")
    expect(page).to have_content("#{credit_card.last_name}")
  end
end