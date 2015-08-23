require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  it{should belong_to(:profile)}
  it{should have_many(:orders).dependent(:destroy)}
  it{should validate_presence_of(:number)}
  it{should validate_presence_of(:cvv)}
  it{should validate_presence_of(:expiration_month)}
  it{should validate_presence_of(:expiration_year)}
  it{should validate_numericality_of(:expiration_year)}
  it{should validate_numericality_of(:expiration_month)}

  describe "expiration_date validation" do
    context "expiration_year <= Time.now.year && expiration_month <= Time.now.month" do
      it "is invalid" do
        credit_card = FactoryGirl.build :credit_card, expiration_year: Time.now.year, expiration_month: Time.now.month - 1
        expect(credit_card).not_to be_valid
      end
    end

    context "expiration_year <= Time.now.year && expiration_month >= Time.now.month" do
      it "is valid" do
        credit_card = FactoryGirl.build :credit_card, expiration_year: Time.now.year, expiration_month: Time.now.month
        expect(credit_card).to be_valid
      end
    end

    context "expiration_year >= Time.now.year && expiration_month <= Time.now.month" do
      it "is valid" do
        credit_card = FactoryGirl.build :credit_card, expiration_year: Time.now.year + 1, expiration_month: Time.now.month - 1
        expect(credit_card).to be_valid
      end
    end

    context "expiration_year < Time.now.year" do
      it "is invalid" do
        credit_card = FactoryGirl.build :credit_card, expiration_year: Time.now.year - 1, expiration_month: Time.now.month + 1
        expect(credit_card).not_to be_valid
      end
    end
  end
  
end
