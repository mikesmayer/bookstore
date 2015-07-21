require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) {FactoryGirl.build :user}

  it{ expect(user).to validate_presence_of(:email) }
  it{ expect(user).to validate_presence_of(:password)}
  it{ expect(user).to validate_uniqueness_of(:email)}
  it{ expect(user).to validate_confirmation_of(:password)}
  it{ expect(user).to validate_length_of(:password)}

  it "creates user profile" do
    expect{user.save}.to change(Profile, :count).by(1)
  end

  describe "#profile_params" do
    it "returns hash with user info" do
      expect(user.profile_params).to eq({email: user.email, password: user.password})
    end
  end

  describe "#role?(role)" do
    context "user.roles includes role" do
      it "returns true" do
        role = Role.create({name: "user"})
        user.roles << role
        expect(user.role?("user")).to eq(true)
      end
    end

    context "user.roles doesn't include role" do
      it "returns false" do
        expect(user.role?("admin")).to eq(false)
      end
    end
  end
end
