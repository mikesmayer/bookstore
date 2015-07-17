require 'rails_helper'

shared_examples "all user with authors" do

  it "has rendered authors contents" do
    expect(view).to render_template('_author', count: 2)
  end
  
  it "has content 'Listing Authors'" do
    expect(rendered).to match /Listing Authors/
  end

  it "has link to show_author_path" do
    expect(rendered).to have_link('Show', href: author_path(author))
  end
end

shared_examples "visitors with authors" do
  it "doesn't have link to edit_author_path" do
    expect(rendered).not_to have_link('Edit')
  end

end

shared_examples "customers with authors" do
  
end

RSpec.describe "authors/index", type: :view do
  let (:author_params){{ id:    10,
                       first_name: "Author First Name",
                       last_name:  "Author Last  Name", 
                       biography:   "Author Biography" }}
  let (:author){stub_model(Author, author_params)}
  
  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
  end

  context "visitor" do
    before do
      assign(:authors, [author, author])
      render
    end

    it_behaves_like "all user with authors"
    it_behaves_like "visitors with authors"
  end

  context "customers" do
    before do
      assign(:authors, [author, author])
      render
    end

    it_behaves_like "all user with authors"
    it_behaves_like "visitors with authors"
    it_behaves_like "customers with authors"
  end

  context "admin" do
    before do
      @ability.can :manage, :author
      assign(:authors, [author, author])
      render
    end

    it_behaves_like "all user with authors"
    it_behaves_like "customers with authors"
  
    it "has link to new_author_path" do
      expect(rendered).to have_link('New Author')
    end

    it "has link to edit_author_path" do
      expect(rendered).to have_link('Edit', href: edit_author_path(author))
    end

    it "has link to destroy_author_path" do
      expect(rendered).to have_link('Destroy', href: author_path(author))
      puts controller
    end
  end
end
