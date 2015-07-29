require 'features/features_spec_helper'

feature 'Approving review by administrator' do
  let!(:review){FactoryGirl.create :review}
  let(:user_admin){FactoryGirl.create :user, :as_admin}
  
  scenario "User can't see not approved review" do
    visit book_path(review.book)
    expect(page).not_to have_content("#{review.text}")
  end

  scenario 'User can see approved review', js: true do
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email',     with: user_admin.email
      fill_in 'Password',  with: user_admin.password
      click_button("Log in")
    end
    review
    visit reviews_path
    find("#label_review_approved_#{review.id}").click
    click_button("Update")
    click_link("Sign out")
    visit book_path("#{review.book_id}")

    expect(page).to have_content("#{review.text}")
  end

end