require 'rails_helper'
 
describe 'devise/registrations/new.html.haml' do

  let(:user) {mock_model("User").as_new_record}

  before do
    allow(user).to receive_messages(email: nil, password: nil, password_confirmation: nil)
    assign(:resource, user)
    render
  end

  it 'has new_user form' do
    expect(rendered).to have_selector('form#new_user')
  end

  it "has user_email field" do
    expect(rendered).to have_selector('#user_email')
  end

  it "has user_password field" do
    expect(rendered).to have_selector('#user_password')
  end

  it "has user_password_confirmation field" do
    expect(rendered).to have_selector('#user_password_confirmation')
  end

  it "has register button" do
    expect(rendered).to have_selector('input[type="submit"]')
  end

end