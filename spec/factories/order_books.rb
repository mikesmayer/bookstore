FactoryGirl.define do
  factory :order_book do
    price     {rand(1..100)}
    quantity  1
    book 
    order nil
  end

end
