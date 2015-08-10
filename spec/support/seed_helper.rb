

def seed_data
  FactoryGirl.create_list( :country, 5)
  FactoryGirl.create :user, :as_admin, email: "admin@example.com", password: "12345678"
  FactoryGirl.create :user, :as_customer, email: "customer@example.com", password: "12345678"
  categories_name = ["novel","drama", "humor", "kids", "fantasy"]
  categories = [ ]
  categories_name.each{|c_n| categories << (FactoryGirl.create :category, category_name: c_n)} 
  authors = [ ]
  20.times {authors << (FactoryGirl.create :author)}

  100.times do
    book = FactoryGirl.create :book, :with_cover, author_id: authors[rand(0..19)].id, category_id: categories[rand(0..4)].id
  end
end
