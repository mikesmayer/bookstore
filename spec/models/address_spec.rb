require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:country_attributes){FactoryGirl.attributes_for :country}
  let(:address){FactoryGirl.build :address}

  it {should belong_to(:country)}
  it {should have_many(:profile_shipping_addresses).with_foreign_key("shipping_address_id")}
  it {should have_many(:profile_billing_addresses).with_foreign_key("billing_address_id")}
  it {should have_many(:order_shipping_addresses).with_foreign_key("shipping_address_id")}
  it {should have_many(:order_billing_addresses).with_foreign_key("billing_address_id")}
  it {should accept_nested_attributes_for(:country)}
  it {should validate_presence_of(:user_address)}
  it {should validate_presence_of(:zipcode)}
  it {should validate_presence_of(:city)}
  it {should validate_presence_of(:zipcode)}
  it {should validate_presence_of(:phone)}
  it {should validate_presence_of(:country_id)}

  describe "#country_exists?" do

    before do
      country = Country.create(country_attributes)
    end

    it "return true if country exists" do
      expect(subject.country_exists?(country_attributes)).to eq(true)
    end

    it "writes assign address country with existing country" do
      subject.country_exists?(country_attributes)
      expect(subject.country.name).to eq(country_attributes[:name])
    end
  end
    



  
end
