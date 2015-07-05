require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do

  let(:user){FactoryGirl.create(:user)}
  let(:user_admin){FactoryGirl.create(:user,:as_admin)}
  let(:valid_attributes)    {{ id:        1,
                              first_name: "First_name", 
                              last_name:  "Last_name", 
                              biography:  "Author_Biography" }}
  let(:new_valid_attributes){{
                              first_name: "New_First_name", 
                              last_name:  "New_Last_name", 
                              biography:  "New_Author_Biography" }.stringify_keys}

  let(:author){mock_model(Author, valid_attributes)}

  before do
    allow(Author).to receive(:all).and_return([author])
    allow(Author).to receive(:new).and_return(author)
    allow(Author).to receive(:find).with(valid_attributes[:id].to_s).and_return(author)
  end

  describe "admin access" do
    before do
      allow(controller).to receive(:current_user).and_return(user_admin)
    end

    describe "GET #index" do
      it "assigns all authors as @authors" do
        get :index
        expect(assigns(:authors)).to eq([author])
      end
    end

    describe "GET #show" do
      before do
        get :show, {id: author.to_param}
      end

      it "assigns @author variable" do
        expect(assigns[:author]).to eql(author)
      end

      it "renders template show" do
        expect(response).to render_template(:show)
      end
    end

    describe "GET #new" do
      before do
        get :new
      end

      it "assigns @author variable" do
        expect(assigns[:author]).to eql(author)
      end

      it "renders new template" do
        expect(response).to render_template(:new)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "redirects to author_path" do
          allow(author).to receive(:save).and_return(true)
          post :create, {:author => valid_attributes}
          expect(response).to redirect_to(author)
        end
      end
  
      context "with invalid params" do
        it "renders 'new' template" do
          allow(author).to receive(:save).and_return(false)
          post :create, {author: valid_attributes}
          expect(response).to render_template(:new)
        end
      end
    end

    describe "GET #edit" do
      before do
        get :edit, valid_attributes
      end
  
      it "assigns @author variable" do
        expect(assigns[:author]).to eql(author)
      end
  
      it "renders new template" do
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        before do
          allow(author).to receive(:update).and_return(true)
          put :update, {:id => author.to_param, author: new_valid_attributes}
        end

        it "assigns @author" do
          expect(assigns[:author]).to eql(author)
        end

        it "receives update for @author" do
          expect(author).to receive(:update).with(new_valid_attributes)
          put :update, {:id => author.to_param, author: new_valid_attributes}
        end

       
        it "redirects to authors_path" do
          expect(response).to redirect_to(author)
        end

        it "sends success notice" do
          expect(flash[:notice]).to eq 'Author was successfully updated.'
        end
      end

      context "with invalid params" do
        before do
          allow(author).to receive(:update).and_return(false)
          put :update, {:id => author.to_param, author: new_valid_attributes}
        end

        it "re-renders edit form" do
          expect(response).to render_template(:edit)
        end

        it "sends error flash" do
          expect(flash[:error]).to eq 'Could not save author.'
        end
      end
    end

    describe "DELETE #destroy" do 
      it "redirects to authors_path" do
        allow(author).to receive(:destroy)
        delete :destroy, {:id => author.to_param}
        expect(response).to redirect_to(authors_path)
      end
    end
  end

  describe "default user access" do
    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    describe "GET #index" do
      it "assigns all authors as @authors" do
        get :index
        expect(assigns(:authors)).to eq([author])
      end
    end

    describe "GET #show" do
      before do
        get :show, {id: author.to_param}
      end

      it "assigns @author variable" do
        expect(assigns[:author]).to eql(author)
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
        post :create, {:author => valid_attributes}
      end

      it "renders error 404 " do
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end

    describe "GET #edit" do
      before do
        get :edit, {:id => author.to_param, author: author}
      end

      it "renders error 404 " do
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end

    describe "PUT #update" do
      before do
        put :update, {:id => author.to_param, author: author}
      end

      it "renders error 404 " do
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end

    describe "DELETE #destroy" do
      before do
        delete :destroy, {:id => author.to_param, author: author}
      end

      it "renders error 404 " do
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end
  end 

end
