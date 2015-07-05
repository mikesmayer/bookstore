FactoryGirl.define do
  factory :book do
    title       {Faker::Lorem.sentence}
    description {Faker::Lorem.paragraph}
    price       {(rand * rand(100)).round(2)}
    quantity    {rand(100)}
  end

  trait :as_string do 
    price       {((rand * rand(100)).round(2)).to_s}
    quantity    {(rand(100)).to_s}
  end

  trait :with_id do
    id {rand(1..10)}
  end

end
