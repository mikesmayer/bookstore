require 'features/features_spec_helper'

feature 'Order creating process', js: true do

  let(:user){FactoryGirl.create :user, :as_customer}
  let!(:book){FactoryGirl.create :book}
  let!(:shipping_address){FactoryGirl.create :address}
  let!(:billing_address){FactoryGirl.create :address}
  let!(:credit_card){FactoryGirl.create :credit_card}
  let!(:country){FactoryGirl.create :country}
  let!(:delivery){FactoryGirl.create :delivery}

  before do

    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email',     with: user.email
      fill_in 'Password',  with: user.password
      click_button("Log in")
    end
    visit root_path
    find("#add_to_cart_book_#{book.id}").click
    find('#cart-button').click
    click_link ('Checkout')

    #address step
    within '#shipping_address_form' do
      fill_in "First name",   with: shipping_address.first_name
      fill_in "Last name",    with: shipping_address.last_name
      fill_in "User address", with: shipping_address.user_address
      fill_in "Zipcode",      with: shipping_address.zipcode
      fill_in "City",         with: shipping_address.city
      fill_in "Phone",        with: shipping_address.phone
    end

    within '#billing_address_form' do
      fill_in "First name",   with: billing_address.first_name
      fill_in "Last name",    with: billing_address.last_name
      fill_in "User address", with: billing_address.user_address
      fill_in "Zipcode",      with: billing_address.zipcode
      fill_in "City",         with: billing_address.city
      fill_in "Phone",        with: billing_address.phone
    end

    click_button "Save and Continue"

    #delivery step
    click_button "Save and Continue"

    # credit_card step
    fill_in "Number",           with: credit_card.number
    fill_in "Cvv",              with: credit_card.cvv
    select "#{credit_card.expiration_month}", :from => 'order_form_credit_card_expiration_month'
    select "#{credit_card.expiration_year}",  :from => 'order_form_credit_card_expiration_year'
    click_button "Save and Continue"
  end
  
  scenario 'User successfully fills out shipping address form'  do
    expect(page).to have_content("Shipping Address")
    expect(page).to have_content("Billing Address")
    expect(page).to have_content("Shipments")
    expect(page).to have_content("Payment Information")
    expect(page).to have_content("$#{Order.last.total_price}")
  end
end