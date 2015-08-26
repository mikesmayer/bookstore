require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do

  let(:valid_attributes)    {FactoryGirl.attributes_for :category}
  let(:category){mock_model(Category, valid_attributes)}

  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    @ability.can :manage, :all
    allow(Category).to receive_message_chain(:where,:all){[category]}
    allow(Category).to receive(:all).and_return([category])
    allow(Category).to receive(:new).and_return(category)
    allow(Category).to receive(:find).with(category.id.to_s).and_return(category)
  end

  describe "cancan negative abilities" do
    context "index" do
      context "cancan doesnt allow :index" do
        before do
          @ability.cannot :index, Category
          get :index
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'show' do
      context 'cancan doesnt allow :show' do
        before do
          @ability.cannot :show, Category
          get :show, {id: category.id}
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'new' do
      context 'cancan doesnt allow :new' do
        before do
          @ability.cannot :new, Category
          get :new
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'edit' do
      context 'cancan doesnt allow :edit' do
        before do
          @ability.cannot :edit, Category
          get :edit, {id: category.id}
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'create' do
      context 'cancan doesnt allow :create' do
        before do
          @ability.cannot :create, Category
          post :create, category: valid_attributes 
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'update' do
      context 'cancan doesnt allow :update' do
        before do
          @ability.cannot :update, Category
          put :update, {id: category.id, category: valid_attributes}
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'destroy' do
      context 'cancan doesnt allow :destroy' do
        before do
          @ability.cannot :destroy, Category
          delete :destroy, {id: category.id}
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end
  end

  describe "GET #index" do
    before do
      get :index
    end
      
    it "assigns all categories as @categories" do
      expect(assigns(:categories)).to eq([category])
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end
  end

  describe "GET #show" do
    before do
      get :show, {id: category.id}
    end

    it "assigns @category to category" do
      expect(assigns[:category]).to eq(category)
    end

    it "render show template" do
      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    
    before do
      get :new
    end

    it "assigns @category to category" do
      expect(assigns[:category]).to eq(category)
    end

    it "render new template" do
      expect(response).to render_template("new")
    end
  end

  describe "GET #edit" do
    before do
      get :edit, {id: category.id}
    end

    it "assigns @category to category" do
      expect(assigns[:category]).to eq(category)
    end

    it "render edit template" do
      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do
    context "invalid params" do
      before do
        allow(category).to receive(:save).and_return(false)
        post :create, {category: valid_attributes}
      end

      it "assigns @category to category" do
        expect(assigns[:category]).to eq(category)
      end

      it "re-renders new template" do
        expect(response).to render_template('new')
      end
    end

    context "valid params" do
      before do
        allow(category).to receive(:save).and_return(true)
        post :create, {category: valid_attributes}
      end

      it "assigns @category to category" do
        expect(assigns[:category]).to eq(category)
      end

      it "redirect_to show category" do
        expect(response).to redirect_to(category_path(category))
      end

      it "sends success message" do
        expect(flash[:notice]).to eq I18n.t("success.notices.create", resource: "Category")
      end
    end

    it "receives save for category" do
      expect(category).to receive(:save)
      post :create, {category: valid_attributes}
    end
  end

  describe "PUT #update" do
    context "invalid params" do
      before do
        allow(category).to receive(:update).and_return(false)
        put :update, {id: category.id, category: valid_attributes}
      end

      it "assigns @category to category " do
        expect(assigns[:category]).to eq(category)
      end

      it "re-renders edit template" do
        expect(response).to render_template('edit')
      end
    end

    context "valid params" do
      before do
        allow(category).to receive(:update).and_return(true)
        put :update, {id: category.id, category: valid_attributes}
      end

      it "assigns @category to category " do
        expect(assigns[:category]).to eq(category)
      end

      it "redirect_to show category" do
        expect(response).to redirect_to(category_path(category))
      end

      it "sends success message" do
        expect(flash[:notice]).to eq I18n.t("success.notices.update", resource: "Category")
      end
    end

    it "receives update for category" do
      expect(category).to receive(:update)
      put :update, {id: category.id, category: valid_attributes}
    end
  end

  describe "DELETE #destroy" do
    before do
      allow(category).to receive(:destroy)
      delete :destroy, {id: category.id}
    end

    it "receives destroy for category" do
      expect(category).to receive(:destroy)
      delete :destroy, {id: category.id}
    end

    it "redirects to category_path " do
      expect(response).to redirect_to(categories_path)
    end

    it "sends success message" do
      expect(flash[:notice]).to eq I18n.t("success.notices.destroy", resource: "Category")
    end
  end
end
