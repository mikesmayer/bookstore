require 'rails_helper'
require 'views/categories/new_category_helper'

RSpec.describe "categories/edit", type: :view do
  it_behaves_like "a new_category_form"
end
