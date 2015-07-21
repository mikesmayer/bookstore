require 'features/features_spec_helper'

feature 'Reviewing books by user' do
  
  let(:user){FactoryGirl.create :user}
  let(:book){FactoryGirl.create :book}

  before do
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email',     with: user.email
      fill_in 'Password',  with: user.password
      click_button("Log in")
    end
  end

  scenario 'User successfully reviews books' do
    book
    visit root_path
    click_link "Show"
    click_link "New Review"
    within '#new_review' do
      find('#rating5').click
      fill_in "Text" , with: "Test Review"
      click_button "Create Review"
    end
  
    expect(page).to have_content('Review was successfully created.')
  end
end