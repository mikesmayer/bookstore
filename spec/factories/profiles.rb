FactoryGirl.define do
  factory :profile do
    credit_card
    billing_address  {(FactoryGirl.create :address)}
    shipping_address {(FactoryGirl.create :address)}
    user
    # email               {User.find(user_id).email}
    # password            {User.find(user_id).password}
    # first_name          {Faker::Name.first_name}
    # last_name           {Faker::Name.last_name}
    # credit_card         
    # billing_address_id  {(FactoryGirl.create :address).id}
    # shipping_address_id {(FactoryGirl.create :address).id}
  end

end
