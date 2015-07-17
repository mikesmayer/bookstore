require 'rails_helper'

RSpec.describe "reviewes/edit", type: :view do
  before(:each) do
    @reviewe = assign(:reviewe, Reviewe.create!())
  end

  it "renders the edit reviewe form" do
    render

    assert_select "form[action=?][method=?]", reviewe_path(@reviewe), "post" do
    end
  end
end
