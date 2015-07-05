FactoryGirl.define do
  factory :category do
    category_name {Faker::Lorem.word}
  end

end
