require 'features/features_spec_helper'

feature "Registration" do
  scenario "Visitor registers successfully via register form" do
    visit register_path
    puts page.body
    within '#new_user' do
      fill_in 'Email',    with: Faker::Internet.email
      fill_in 'Password', with: Faker::Internet.password
      click_button('Sign Up')
    end
    expect(page).not_to have_content 'Sign up'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'You registered'
  end
end