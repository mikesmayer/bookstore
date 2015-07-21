require 'rails_helper'

RSpec.describe Author, type: :model do
  let(:author){FactoryGirl.create(:author)}
  
  it { should validate_presence_of (:first_name) }
  it { should validate_presence_of (:last_name) }
  it { should validate_presence_of (:biography)}
  it { should have_many(:books).dependent(:destroy)}

  it "is invalid if full name isn't uniq" do
    expect(author).not_to be_valid
  end

  describe "#full_name" do
    it "return author author full name" do
      expect(author.full_name).to eq("#{author.first_name} #{author.last_name}")
    end
  end

end
