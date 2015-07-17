require 'rails_helper'

RSpec.describe Book, type: :model do

  let(:book){FactoryGirl.build(:book)}

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:quantity) }
  it { should validate_numericality_of(:price).is_greater_than(0) }
  it { should validate_numericality_of(:quantity).is_greater_than(0) }
  it { should belong_to(:author)}
  it { should belong_to(:category)}
  it { should have_many(:reviews)}
  
  it "can be valid" do
    expect(book).to be_valid
  end

end
