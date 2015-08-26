require 'features/features_spec_helper'

feature "Administrator books CRUD actions" do

  let(:new_book){FactoryGirl.build(:book)}
  let(:author){FactoryGirl.create(:author)}
  let(:category){FactoryGirl.create(:category)}
  let(:existing_book){FactoryGirl.create(:book)}
  let(:user_admin){FactoryGirl.create(:user,:as_admin)}

  before do
    visit root_path
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email',     with: user_admin.email
      fill_in 'Password',  with: user_admin.password
      click_button("Log in")
    end
  end

  scenario "Administrator successfully creates new book" do
    author
    category
    visit new_book_path
    within '#new_book' do
      page.all("select", :visible => true)
      fill_in 'Title',        with: new_book.title
      fill_in 'Description',  with: new_book.description
      fill_in 'Price',        with: new_book.price
      fill_in 'Quantity',     with: new_book.quantity
      select("#{author.full_name}", :from => 'Author')
      select("#{category.category_name}", :from => 'Category')
      click_button("Save")
    end

    expect(page).to have_content "#{new_book.title}"
    expect(page).to have_content "#{new_book.description}"
    expect(page).to have_content "#{new_book.price}"
  end

  scenario 'Administrator successfully edits book' do
    visit edit_book_path(existing_book)
    within "#edit_book_#{existing_book.id}" do
      fill_in 'Price', with: 999
      click_button("Save")
      visit books_path(existing_book)
    end

    expect(page).to have_content "999"
  end

  scenario 'Administrator successfully deletes book' do
    existing_book
    visit books_path
    find("a[href='/books/#{existing_book.id}'][data-method='delete']").click

    expect(page).to have_content("Book was successfully destroyed.")
  end

end