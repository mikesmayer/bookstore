require 'features/features_spec_helper'

feature 'Administrator authors CRUD actions' do
  let(:new_author){FactoryGirl.build(:author)}
  let(:existing_author){FactoryGirl.create(:author)}
  let(:user_admin){FactoryGirl.create(:user,:as_admin)}

  before do
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email',     with: user_admin.email
      fill_in 'Password',  with: user_admin.password
      click_button("Log in")
    end
  end

  scenario "Administrator successfully creates new author" do 
    visit new_author_path
    within '#new_author' do
      fill_in 'First name', with: new_author.first_name
      fill_in 'Last name',  with: new_author.last_name
      fill_in 'Biography',  with: new_author.biography
      click_button("Save")
      visit authors_path
    end
    
    expect(page).to have_content "#{new_author.first_name}"
    expect(page).to have_content "#{new_author.last_name}"
    expect(page).to have_content "#{new_author.biography}"
  end

  scenario 'Administrator successfully edits author' do
    visit edit_author_path(existing_author)
    within "#edit_author_#{existing_author.id}" do
      fill_in 'First name', with: "#{new_author.first_name}"
      click_button("Save")
      visit authors_path(existing_author)
    end

    expect(page).to have_content "#{new_author.first_name}"
  end

  scenario 'Administrator successfully deletes book' do
    existing_author
    visit authors_path
    find("a[href='/authors/#{existing_author.id}'][data-method='delete']").click

    expect(page).to have_content("Author was successfully destroyed.")
  end
end