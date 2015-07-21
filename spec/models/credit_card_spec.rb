require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  it{should belong_to(:profile)}
  it{should have_many(:orders).dependent(:destroy)}
  it{should validate_presence_of(:number)}
  it{should validate_presence_of(:cvv)}
  it{should validate_presence_of(:expiration_month)}
  it{should validate_presence_of(:expiration_year)}
  it{should validate_presence_of(:first_name)}
  it{should validate_presence_of(:last_name)}
  it{should validate_numericality_of(:expiration_year).is_greater_than_or_equal_to(Time.now.year)}
  it{should validate_numericality_of(:expiration_month).is_greater_than_or_equal_to(Time.now.month)}


end
