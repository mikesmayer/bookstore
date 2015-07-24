FactoryGirl.define do

  factory :user do
    email    {Faker::Internet.email}
    password {Faker::Internet.password}
  end

  trait :as_admin do
    after(:create) do |user|
      user.roles << create(:role, :admin) 
    end
  end

  trait :as_customer do
    after(:create) do |user|
      user.roles << create(:role, :customer)
    end
  end

  

end
