FactoryGirl.define do

  factory :role do
    name "user"
  end

  trait :admin do
    name   "admin"
  end

  

end
