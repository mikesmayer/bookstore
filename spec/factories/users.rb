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

  

end
