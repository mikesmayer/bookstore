require 'rails_helper'

RSpec.describe "reviewes/index", type: :view do
  before(:each) do
    assign(:reviewes, [
      Reviewe.create!(),
      Reviewe.create!()
    ])
  end

  it "renders a list of reviewes" do
    render
  end
end
