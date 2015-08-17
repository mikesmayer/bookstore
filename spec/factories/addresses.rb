FactoryGirl.define do
  factory :address do
    first_name   {Faker::Name.first_name}
    last_name    {Faker::Name.last_name}
    user_address {Faker::Address.street_address}
    zipcode      {Faker::Address.zip_code}
    city         {Faker::Address.city}
    phone        {Faker::PhoneNumber.cell_phone}
    country      
  end

  trait :with_country_attrs do
    country_attributes  {(FactoryGirl.attributes_for :country)}
  end 

end
