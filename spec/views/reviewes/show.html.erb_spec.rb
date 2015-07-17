require 'rails_helper'

RSpec.describe "reviewes/show", type: :view do
  before(:each) do
    @reviewe = assign(:reviewe, Reviewe.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
