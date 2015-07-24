FactoryGirl.define do


  factory :role do
    name "customer"
  end

  trait :admin do
    name   "admin"
  end

  trait :customer do
    name   "customer"
  end

  

end
