require 'rails_helper'

shared_examples "all user show_category" do

  it "has book_title content" do
    expect(rendered).to have_content(category.category_name)
  end

  it "has link to categories_path" do
    expect(rendered).to have_link('Back', href: categories_path)
  end
end

RSpec.describe "categories/show", type: :view do
  let (:category){FactoryGirl.create(:category)}

  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
  end


  context "all users" do
    before do
      assign(:category, category)
      render
    end

    it_behaves_like "all user show_category"

    it "doesn't have link to edit_category_path" do
      expect(rendered).not_to have_link('Edit')
    end
  end

  context "admin" do
    before do
      @ability.can :manage, :category
      assign(:category, category)
      render
    end
    
    it_behaves_like "all user show_category"

    it "has link to edit_category_path" do
      expect(rendered).to have_link('Edit')
    end
  end
end

