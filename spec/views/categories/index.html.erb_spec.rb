require 'rails_helper'

RSpec.shared_examples "all user categories" do

  it "has rendered category contents" do
    expect(view).to render_template('_category', count: 2)
  end
  
  it "has content 'Listing Categories'" do
    expect(rendered).to match /Listing Categories/
  end

  it "has link to show_category_path" do
    expect(rendered).to have_link('Show', href: category_path(category))
  end
end

RSpec.shared_examples "visitors categories" do
  it "doesn't have link to edit_category_path" do
    expect(rendered).not_to have_link('Edit')
  end

end

RSpec.shared_examples "customers categories" do
  
end

RSpec.describe "categories/index", type: :view do
  let (:category_params){{ id:    10,
                       category_name: "Category_name"}}
  let (:category){stub_model(Category, category_params)}
  
  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
  end

  context "visitor" do
    before do
      assign(:categories, [category, category])
      render
    end

    it_behaves_like "all user categories"
    it_behaves_like "visitors categories"
  end

  context "customers" do
    before do
      assign(:categories, [category, category])
      render
    end

    it_behaves_like "all user categories"
    it_behaves_like "visitors categories"
    it_behaves_like "customers categories"
  end

  context "admin" do
    before do
      @ability.can :manage, :category
      assign(:categories, [category, category])
      render
    end

    it_behaves_like "all user categories"
  
    it "has link to new_category_path" do
      expect(rendered).to have_link('New Category')
    end

    it "has link to edit_book_path" do
      expect(rendered).to have_link('Edit', href: edit_category_path(category))
    end

    it "has link to destroy_book_path" do
      expect(rendered).to have_link('Destroy', href: category_path(category))
    end
  end
end


