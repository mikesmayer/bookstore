FactoryGirl.define do
  factory :book do
    title       {Faker::Lorem.sentence}
    description {Faker::Lorem.paragraph}
    price       {(rand * rand(100)).round(2)}
    quantity    {rand(100)}
  end

end
