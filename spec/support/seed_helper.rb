

def seed_data
  
    book = FactoryGirl.build :book, category: FactoryGirl.create(:category)
    file = File.open(File.join(Rails.root, '/public/uploads/book/cover/100/51BYvUcML_2BL._SX329_BO1_204_203_200_.jpg'))
    book.cover = file
    file.close
    book.save!


end
