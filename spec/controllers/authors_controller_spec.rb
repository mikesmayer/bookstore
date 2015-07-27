require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do

  let(:valid_attributes) {FactoryGirl.attributes_for :author}
  let(:author){mock_model(Author, valid_attributes)}

  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    @ability.can :manage, :all
    allow(Author).to receive(:all).and_return([author])
    allow(Author).to receive_message_chain(:where, :all){[author]}
    allow(Author).to receive(:new).and_return(author)
    allow(Author).to receive(:find).with(author.id.to_s).and_return(author)
  end

  describe "cancan negative abilities" do
    context "index" do
      context "cancan doesnt allow :index" do
        before do
          @ability.cannot :index, Author
          get :index
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'show' do
      context 'cancan doesnt allow :show' do
        before do
          @ability.cannot :show, Author
          get :show, {id: author.id}
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'new' do
      context 'cancan doesnt allow :new' do
        before do
          @ability.cannot :new, Author
          get :new
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'edit' do
      context 'cancan doesnt allow :edit' do
        before do
          @ability.cannot :edit, Author
          get :edit, {id: author.id}
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'create' do
      context 'cancan doesnt allow :create' do
        before do
          @ability.cannot :create, Author
          post :create, author: valid_attributes 
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'update' do
      context 'cancan doesnt allow :update' do
        before do
          @ability.cannot :update, Author
          put :update, {id: author.id, author: valid_attributes}
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'destroy' do
      context 'cancan doesnt allow :destroy' do
        before do
          @ability.cannot :destroy, Author
          delete :destroy, {id: author.id}
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end
  end

    describe "GET #index" do
    before do
      get :index
    end
      
    it "assigns all authors as @authors" do
      expect(assigns(:authors)).to eq([author])
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end
  end

  describe "GET #show" do
    before do
      get :show, {id: author.id}
    end

    it "assigns @author to author" do
      expect(assigns[:author]).to eq(author)
    end

    it "render show template" do
      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    
    before do
      get :new
    end

    it "assigns @author to author" do
      expect(assigns[:author]).to eq(author)
    end

    it "render new template" do
      expect(response).to render_template("new")
    end
  end

  describe "GET #edit" do
    before do
      get :edit, {id: author.id}
    end

    it "assigns @author to author" do
      expect(assigns[:author]).to eq(author)
    end

    it "render edit template" do
      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do
    context "invalid params" do
      before do
        allow(author).to receive(:save).and_return(false)
        post :create, {author: valid_attributes}
      end

      it "assigns @author to author" do
        expect(assigns[:author]).to eq(author)
      end

      it "re-renders new template" do
        expect(response).to render_template('new')
      end
    end

    context "valid params" do
      before do
        allow(author).to receive(:save).and_return(true)
        post :create, {author: valid_attributes}
      end

      it "assigns @author to author" do
        expect(assigns[:author]).to eq(author)
      end

      it "redirect_to show author" do
        expect(response).to redirect_to(author_path(author))
      end

      it "sends success message" do
        expect(flash[:notice]).to eq 'Author was successfully created.'
      end
    end

    it "receives save for author" do
      expect(author).to receive(:save)
      post :create, {author: valid_attributes}
    end
  end

  describe "PUT #update" do
    context "invalid params" do
      before do
        allow(author).to receive(:update).and_return(false)
        put :update, {id: author.id, author: valid_attributes}
      end

      it "assigns @author to author " do
        expect(assigns[:author]).to eq(author)
      end

      it "re-renders edit template" do
        expect(response).to render_template('edit')
      end
    end

    context "valid params" do
      before do
        allow(author).to receive(:update).and_return(true)
        put :update, {id: author.id, author: valid_attributes}
      end

      it "assigns @author to author " do
        expect(assigns[:author]).to eq(author)
      end

      it "redirect_to show author" do
        expect(response).to redirect_to(author_path(author))
      end

      it "sends success message" do
        expect(flash[:notice]).to eq 'Author was successfully updated.'
      end
    end

    it "receives update for author" do
      expect(author).to receive(:update)
      put :update, {id: author.id, author: valid_attributes}
    end
  end

  describe "DELETE #destroy" do
    before do
      allow(author).to receive(:destroy)
      delete :destroy, {id: author.id}
    end

    it "receives destroy for author" do
      expect(author).to receive(:destroy)
      delete :destroy, {id: author.id}
    end

    it "redirects to author_path " do
      expect(response).to redirect_to(authors_path)
    end

    it "sends success message" do
      expect(flash[:notice]).to eq 'Author was successfully destroyed.'
    end

    
  end
end
