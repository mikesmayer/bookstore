require 'features/features_spec_helper'

feature "Addministrator can add book" do

  let(:user_admin){FactoryGirl.create(:user,:as_admin)}

  before do

    visit new_user_session_path

  end


  scenario "Visitor signs in successfully as admin" do

    within '#new_user' do
      fill_in 'Email',     with: user_admin.email
      fill_in 'Password',  with: user_admin.password
      click_button("Log in")
    end

    expect(page).to have_content 'HelloAdmin!'

  end

end