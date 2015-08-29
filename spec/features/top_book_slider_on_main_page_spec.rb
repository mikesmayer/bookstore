require "features/features_spec_helper"

feature "User can check between home and shop "  do

  let!(:books_in_stock){FactoryGirl.create_list :book, 10}
  OrderBook.group(:book_id).count.sort_by{|k, v| v}.last(3).map!(&:first)
  before do
    visit root_path
    click_link("SHOP")
  end

  scenario "User successfully visit store" ,js: true do
    expect(page).to have_current_path("#{Rails.root}/shop")
  end
end