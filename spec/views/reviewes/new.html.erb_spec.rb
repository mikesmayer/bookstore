require 'rails_helper'

RSpec.describe "reviewes/new", type: :view do
  before(:each) do
    assign(:reviewe, Reviewe.new())
  end

  it "renders new reviewe form" do
    render

    assert_select "form[action=?][method=?]", reviewes_path, "post" do
    end
  end
end
