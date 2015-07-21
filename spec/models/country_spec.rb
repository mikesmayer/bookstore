require 'rails_helper'

RSpec.describe Country, type: :model do
  it{should have_many(:addresses).dependent(:destroy)}
  it{should validate_presence_of(:name)}
end
