FactoryGirl.define do
  factory :book do
    title       {Faker::Lorem.sentence}
    description {Faker::Lorem.paragraph}
    price       {(rand * rand(1..10)).round(2)}
    quantity    {rand(1..100)}
    author      
    category    
  end

  trait :as_string do 
    price       {((rand * rand(1..10)).round(2)).to_s}
    quantity    {(rand(1..100)).to_s}
  end

  trait :with_id do
    id {rand(1..10)}
  end

end
