require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  let(:user){FactoryGirl.create(:user)}
  let(:user_admin){FactoryGirl.create(:user,:as_admin)}
  let(:valid_attributes)    {{ id:         1,
                              title:       "Title", 
                              description: "Description", 
                              price:       11.11, 
                              quantity:    10 }}
  let(:new_valid_attributes){{
                              title:       "Title", 
                              description: "Description", 
                              price:       "11.11", 
                              quantity:    "10" }.stringify_keys}

  let(:book){mock_model(Book, valid_attributes)}

  before do
    allow(Book).to receive(:all).and_return([book])
    allow(Book).to receive(:new).and_return(book)
    allow(Book).to receive(:find).with(valid_attributes[:id].to_s).and_return(book)
  end

  describe "admin access" do
    before do
      allow(controller).to receive(:current_user).and_return(user_admin)
    end

    describe "GET #index" do
      it "assigns all books as @books" do
        get :index
        expect(assigns(:books)).to eq([book])
      end
    end

    describe "GET #show" do
      before do
        get :show, {id: book.to_param}
      end

      it "assigns @book variable" do
        expect(assigns[:book]).to eql(book)
      end

      it "renders template show" do
        expect(response).to render_template(:show)
      end
    end

    describe "GET #new" do
      before do
        get :new
      end

      it "assigns @book variable" do
        expect(assigns[:book]).to eql(book)
      end

      it "renders new template" do
        expect(response).to render_template(:new)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "redirects to books_path" do
          allow(book).to receive(:save).and_return(true)
          post :create, {:book => valid_attributes}
          expect(response).to redirect_to(book)
        end
      end
  
      context "with invalid params" do
        it "renders 'new' template" do
          allow(book).to receive(:save).and_return(false)
          post :create, {book: valid_attributes}
          expect(response).to render_template(:new)
        end
      end
    end

    describe "GET #edit" do
      before do
        get :edit, valid_attributes
      end
  
      it "assigns @book variable" do
        expect(assigns[:book]).to eql(book)
      end
  
      it "renders new template" do
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        before do
          allow(book).to receive(:update).and_return(true)
          put :update, {:id => book.to_param, book: new_valid_attributes}
        end

        it "assigns @book" do
          expect(assigns[:book]).to eql(book)
        end

        it "receives update for @book" do
          expect(book).to receive(:update).with(new_valid_attributes)
          put :update, {:id => book.to_param, book: new_valid_attributes}
        end

       
        it "redirects to books_path" do
          expect(response).to redirect_to(book)
        end

        it "sends success notice" do
          expect(flash[:notice]).to eq 'Book was successfully updated.'
        end
      end

      context "with invalid params" do
        before do
          allow(book).to receive(:update).and_return(false)
          put :update, {:id => book.to_param, book: new_valid_attributes}
        end

        it "re-renders edit form" do
          expect(response).to render_template(:edit)
        end

        it "sends error flash" do
          expect(flash[:error]).to eq 'Could not save book.'
        end
      end
    end

    describe "DELETE #destroy" do 
      it "redirects to books_path" do
        allow(book).to receive(:destroy)
        delete :destroy, {:id => book.to_param}
        expect(response).to redirect_to(books_path)
      end
    end
  end

  describe "default user access" do
    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    describe "GET #index" do
      it "assigns all books as @books" do
        get :index
        expect(assigns(:books)).to eq([book])
      end
    end

    describe "GET #show" do
      before do
        get :show, {id: book.to_param}
      end

      it "assigns @book variable" do
        expect(assigns[:book]).to eql(book)
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
        
      # it "sends error flash" do
      #   expect(flash[:error]).to eq 'You are not authorized to access this page.'
      # end
    end

    describe "POST #create" do
      before do
        post :create, {:book => valid_attributes}
      end

      it "renders error 404 " do
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end

    describe "GET #edit" do
      before do
        get :edit, {:id => book.to_param, book: book}
      end

      it "renders error 404 " do
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end

    describe "PUT #update" do
      before do
        put :update, {:id => book.to_param, book: book}
      end

      it "renders error 404 " do
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end


    describe "DELETE #destroy" do
      before do
        delete :destroy, {:id => book.to_param, book: book}
      end

      it "renders error 404 " do
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end
  end 
end
