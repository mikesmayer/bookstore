FactoryGirl.define do
  factory :author do
    first_name  {Faker::Name.first_name}
    last_name   {Faker::Name.last_name}
    biography   {Faker::Lorem.paragraph}
  end
end
