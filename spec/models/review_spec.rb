require 'rails_helper'

RSpec.describe Review, type: :model do
  it{should belong_to(:user)}
  it{should belong_to(:book)}
  it{should validate_presence_of(:text)}
  it{should validate_presence_of(:rating)}
  it{should validate_numericality_of(:rating).is_greater_than(0)}
  it{should validate_numericality_of(:rating).is_less_than(6)}
end
