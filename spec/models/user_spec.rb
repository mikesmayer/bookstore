require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) {FactoryGirl.build :user}
  let(:book) {FactoryGirl.create :book}

  it{ expect(user).to validate_presence_of(:email) }
  it{ expect(user).to validate_presence_of(:password)}
  it{ expect(user).to validate_uniqueness_of(:email)}
  it{ expect(user).to validate_confirmation_of(:password)}
  it{ expect(user).to validate_length_of(:password)}

  it "creates user profile" do
    expect{user.save}.to change(Profile, :count).by(1)
  end


 it "does something" do
   user.books << book
   p user.books
   p book.users
 end

end
