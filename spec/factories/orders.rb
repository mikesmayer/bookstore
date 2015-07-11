FactoryGirl.define do
  factory :order do
    total_price "9.99"
completed_date "2015-07-11 10:45:04"
billing_address nil
shipping_address nil
status "MyString"
customer nil
credit_card nil
  end

end
