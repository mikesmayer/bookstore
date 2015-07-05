require 'rails_helper'

RSpec.describe Author, type: :model do
  let(:author){FactoryGirl.create(:author)}
  
  it { should validate_presence_of (:first_name) }
  it { should validate_presence_of (:last_name) }
  it { should validate_presence_of (:biography)}
  it { should have_many(:books)}

  it "is invalid if full name isn't uniq" do
    expect(author).not_to be_valid
  end

end
