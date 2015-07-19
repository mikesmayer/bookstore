FactoryGirl.define do
  factory :credit_card do
    number            {Faker::Business.credit_card_number}
    cvv               777
    expiration_month  12
    expiration_year   2017
    first_name        {Faker::Name.first_name}
    last_name         {Faker::Name.first_name}
  end
end
