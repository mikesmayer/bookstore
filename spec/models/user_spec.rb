require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) {FactoryGirl.create :user}

  it{ expect(user).to validate_presence_of(:email) }
  it{ expect(user).to validate_presence_of(:password)}
  it{ expect(user).to validate_uniqueness_of(:email)}

end
