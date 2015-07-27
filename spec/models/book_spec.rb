require 'rails_helper'

RSpec.describe Book, type: :model do

  let(:book){FactoryGirl.build(:book)}

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:category_id) }
  it { should validate_presence_of(:author_id) }
  it { should validate_numericality_of(:price).is_greater_than(0) }
  it { should validate_numericality_of(:quantity).is_greater_than(0) }
  it { should belong_to(:author)}
  it { should belong_to(:category)}
  it { should have_many(:reviews)}

  describe ".to_hash" do
    it "return hash with books params" do
      book.save
      expect(Book.to_hash(book.id)).to eq({id: book.id, 
                                           title: book.title, 
                                           price: book.price, 
                                           quantity: 1})
    end
  end
  
  it "can be valid" do
    expect(book).to be_valid
  end

  it "dsfdsf" do
    p FactoryGirl.create :book, :with_cover
  end

end
