require 'features/features_spec_helper'

feature "Registration" do
  scenario "Visitor registers successfully via register form" do
    visit new_user_registration_path
    within '#new_user' do
      fill_in 'Email',    with: Faker::Internet.email
      password = Faker::Internet.password
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password
      click_button('Sign up')
    end
    expect(page).not_to have_content 'Sign up'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  
end