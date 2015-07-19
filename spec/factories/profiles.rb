FactoryGirl.define do
  factory :profile do
    user 
    email               {user.email}
    password            {user.password}
    first_name          {Faker::Name.first_name}
    last_name           {Faker::Name.last_name}
    credit_card 
    billing_address_id  {(FactoryGirl.create :address).id}
    shipping_address_id {(FactoryGirl.create :address).id}
  end

end
