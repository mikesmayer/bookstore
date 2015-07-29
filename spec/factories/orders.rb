FactoryGirl.define do
  factory :order do
    total_price       {rand(1..100)}
    completed_date    "2015-07-11 10:45:04"
    billing_address   {FactoryGirl.create :address}
    shipping_address  {FactoryGirl.create :address}
    credit_card       {FactoryGirl.create :credit_card}
    user
    status "creating"

    after(:build) do |order| 
      book = FactoryGirl.create :book
      order.ordered_books = [{"id" => book.id, "quantity" => rand(1..book.quantity)}]
    end

  end
end
