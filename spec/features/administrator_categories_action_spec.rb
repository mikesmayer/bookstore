require 'features/features_spec_helper'

feature 'Administrator categories CRUD actions' do
  let(:new_category){FactoryGirl.build(:category)}
  let(:existing_category){FactoryGirl.create(:category)}
  let(:user_admin){FactoryGirl.create(:user,:as_admin)}

  before do
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email',     with: user_admin.email
      fill_in 'Password',  with: user_admin.password
      click_button("Log in")
    end
  end

  scenario "Administrator successfully creates new category" do
    visit new_category_path
    within '#new_category' do
      fill_in 'Category name',    with: new_category.category_name
      click_button("Save")
      visit categories_path
    end

    expect(page).to have_content "#{new_category.category_name}"
  end

  scenario 'Administrator successfully edits category' do
    visit edit_category_path(existing_category)
    within "#edit_category_#{existing_category.id}" do
      fill_in 'Category name', with: "Change category name"
      click_button("Save")
      visit categories_path(existing_category)
    end

    expect(page).to have_content "Change category name"
  end

  scenario 'Administrator successfully deletes category' do
    existing_category
    visit categories_path
    find("a[href='/categories/#{existing_category.id}'][data-method='delete']").click
    expect(page).to have_content("Category was successfully destroyed.")
  end
end