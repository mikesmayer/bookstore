require 'rails_helper'
require 'views/authors/new_author_helper'

RSpec.describe "authors/new", type: :view do
  it_behaves_like 'a new_author_form'
end



