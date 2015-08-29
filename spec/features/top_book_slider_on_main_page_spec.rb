require "features/features_spec_helper"

feature "User can visit home and shop page"  do

  let!(:books_in_stock){FactoryGirl.create_list :book, 10}
  before do
    visit root_path
    click_link("SHOP")
  end

  scenario "User successfully visit shop page" ,js: true do
    expect(page).to have_css(".card", count: books_in_stock.length)
  end

  scenario 'User successfully visit home page' do
    click_link("HOME")
    expect(page).to have_content("Welcome")
  end
end