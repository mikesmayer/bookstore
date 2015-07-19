FactoryGirl.define do
  factory :review do
    rating 4
    text {Faker::Lorem.paragraph}
    user 
    book {FactoryGirl.create :book}
  end

end
