require 'rails_helper'

RSpec.describe Category, type: :model do
  it {should validate_presence_of(:category_name)}
  it {should validate_uniqueness_of(:category_name)}
  it {should have_many(:books).dependent(:destroy)}
end
