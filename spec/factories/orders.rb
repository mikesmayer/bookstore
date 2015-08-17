FactoryGirl.define do
  factory :order do
    total_price       {rand(1..100)}
    completed_date    "2015-07-11 10:45:04"
    billing_address   {FactoryGirl.create :address}
    shipping_address  {FactoryGirl.create :address}
    credit_card       {FactoryGirl.create :credit_card}
    user
    # status ""

   after(:build) do |order| 
     book = FactoryGirl.create :book
     # order.add_book(book,10)
     # p order.books
   end

  end
end
