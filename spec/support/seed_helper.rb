

def seed_data
  categories_name = ["novel","drama", "humor", "kids", "fantasy"]
  categories = [ ]
  categories_name.each{|c_n| categories << (FactoryGirl.create :category, category_name: c_n)} 
  authors = [ ]
  20.times {authors << (FactoryGirl.create :author)}

  100.times do
    book = FactoryGirl.create :book, :with_cover, author_id: authors[rand(0..19)].id, category_id: categories[rand(0..4)].id
  end
end
