require 'rails_helper'

shared_examples "all user show_author" do

  it "has author_first_name content" do
    expect(rendered).to have_content(author.first_name)
  end

  it "has author_last_name content" do
    expect(rendered).to have_content(author.last_name)
  end

  it "has author_biography content" do
    expect(rendered).to have_content(author.biography)
  end

  it "has link to authors_path" do
    expect(rendered).to have_link('Back', href: authors_path)
  end
end

RSpec.describe "authors/show", type: :view do

  let (:author_params){ FactoryGirl.attributes_for(:author)}
  let (:author){stub_model(Author, author_params)}

  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
  end


  context "all users" do
    before do
      assign(:author, author)
      render
    end

    it_behaves_like "all user show_author"

    it "doesn't have link to edit_author_path" do
      expect(rendered).not_to have_link('Edit')
    end
  end

  context "admin" do
    before do
      @ability.can :manage, :author
      assign(:author, author)
      render
    end

    it_behaves_like "all user show_author"

    it "has link to edit_author_path" do
      expect(rendered).to have_link('Edit')
    end
  end
end
