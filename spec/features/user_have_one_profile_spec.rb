require 'features/features_spec_helper'

feature 'User has one profile with contact info' do
  
  scenario 'After registering user has his own profile ', js: true do
    visit new_user_registration_path
    within "#new_user" do
      fill_in 'Email',                  with: "example@example.com"
      fill_in 'Password',               with: "12345678"
      fill_in 'Password confirmation',  with: "12345678"
      click_button("Sign up")
    end
    
    click_link "Profile"
    expect(page).to have_content("example@example.com")
    expect(page).to have_content("Edit")
  end
end