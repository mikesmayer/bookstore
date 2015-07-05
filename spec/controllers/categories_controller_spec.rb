require 'rails_helper'


RSpec.describe CategoriesController, type: :controller do

  let(:user){FactoryGirl.create(:user)}
  let(:user_admin){FactoryGirl.create(:user,:as_admin)}
  let(:valid_attributes)    {{ id:           1,
                              category_name: "Category_name" }}
  let(:new_valid_attributes){{category_name: "New_Category_name" }.stringify_keys}

  let(:category){mock_model(Category, valid_attributes)}

  before do
    allow(Category).to receive(:all).and_return([category])
    allow(Category).to receive(:new).and_return(category)
    allow(Category).to receive(:find).with(valid_attributes[:id].to_s).and_return(category)
  end

  describe "admin access" do
    before do
      allow(controller).to receive(:current_user).and_return(user_admin)
    end

    describe "GET #index" do
      it "assigns all catigories as @categories" do
        get :index
        expect(assigns(:categories)).to eq([category])
      end
    end

    describe "GET #show" do
      before do
        get :show, {id: category.to_param}
      end

      it "assigns @category variable" do
        expect(assigns[:category]).to eql(category)
      end

      it "renders template show" do
        expect(response).to render_template(:show)
      end
    end

    describe "GET #new" do
      before do
        get :new
      end

      it "assigns @category variable" do
        expect(assigns[:category]).to eql(category)
      end

      it "renders new template" do
        expect(response).to render_template(:new)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "redirects to category_path" do
          allow(category).to receive(:save).and_return(true)
          post :create, {:category => valid_attributes}
          expect(response).to redirect_to(category)
        end
      end
  
      context "with invalid params" do
        it "renders 'new' template" do
          allow(category).to receive(:save).and_return(false)
          post :create, {category: valid_attributes}
          expect(response).to render_template(:new)
        end
      end
    end

    describe "GET #edit" do
      before do
        get :edit, valid_attributes
      end
  
      it "assigns @category variable" do
        expect(assigns[:category]).to eql(category)
      end
  
      it "renders new template" do
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        before do
          allow(category).to receive(:update).and_return(true)
          put :update, {:id => category.to_param, category: new_valid_attributes}
        end

        it "assigns @category" do
          expect(assigns[:category]).to eql(category)
        end

        it "receives update for @category" do
          expect(category).to receive(:update).with(new_valid_attributes)
          put :update, {:id => category.to_param, category: new_valid_attributes}
        end

       
        it "redirects to categories_path" do
          expect(response).to redirect_to(category)
        end

        it "sends success notice" do
          expect(flash[:notice]).to eq 'Category was successfully updated.'
        end
      end

      context "with invalid params" do
        before do
          allow(category).to receive(:update).and_return(false)
          put :update, {:id => category.to_param, category: new_valid_attributes}
        end

        it "re-renders edit form" do
          expect(response).to render_template(:edit)
        end

        it "sends error flash" do
          expect(flash[:error]).to eq 'Could not save category.'
        end
      end
    end

    describe "DELETE #destroy" do 
      it "redirects to categories_path" do
        allow(category).to receive(:destroy)
        delete :destroy, {:id => category.to_param}
        expect(response).to redirect_to(categories_path)
      end
    end
  end

  describe "default user access" do
    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    describe "GET #index" do
      it "assigns all categories as @categories" do
        get :index
        expect(assigns(:categories)).to eq([category])
      end
    end

    describe "GET #show" do
      before do
        get :show, {id: category.to_param}
      end

      it "assigns @categories variable" do
        expect(assigns[:category]).to eql(category)
      end

      it "renders template show" do
        expect(response).to render_template(:show)
      end
    end

    describe "GET #new" do
      before do
        get :new
      end

      it "renders error 404 " do
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end

    describe "POST #create" do
      before do
        post :create, {:category => valid_attributes}
      end

      it "renders error 404 " do
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end

    describe "GET #edit" do
      before do
        get :edit, {:id => category.to_param, category: category}
      end

      it "renders error 404 " do
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end

    describe "PUT #update" do
      before do
        put :update, {:id => category.to_param, category: category}
      end

      it "renders error 404 " do
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end


    describe "DELETE #destroy" do
      before do
        delete :destroy, {:id => category.to_param, category: category}
      end

      it "renders error 404 " do
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end
  end 

end
