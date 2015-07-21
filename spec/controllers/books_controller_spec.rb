require 'rails_helper'

RSpec.describe BooksController, type: :controller do


  let(:author){FactoryGirl.create :author}
  let(:visitor){User.new}
  let(:user){FactoryGirl.create(:user)}
  let(:user_admin){FactoryGirl.create(:user,:as_admin)}
  let(:valid_attributes){FactoryGirl.attributes_for(:book, :with_id)}
  let(:new_valid_attributes){FactoryGirl.attributes_for(:book, :as_string)}
  let(:book){mock_model(Book, valid_attributes)}
  let(:book_hash){{ "id" => book.id,
                     "author"=>book.author.full_name,
                     "title"=> book.title,
                     "price"=> book.price,
                     "quantity" => 1
                     }}
  

  before do
    allow(Book).to receive(:all).and_return([book])
    allow(Book).to receive(:new).and_return(book)
    allow(Book).to receive(:find).with(valid_attributes[:id].to_s).and_return(book)
  end

  context "user is admin" do
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
          post :create, book: valid_attributes
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

  context "all user access" do
    before do
      allow(controller).to receive(:current_user).and_return(visitor)
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

    describe "PUT #add_to_cart" do
      before do
        controller.add_cart
        allow(book).to receive(:author).and_return(author)
        xhr :put, :add_to_cart, {:id => valid_attributes[:id]}
      end

      it "render template add_to_cart" do 
        expect(response).to render_template("books/add_to_cart")
      end

      it "write book to session[:cart][:books]" do
        expect(session["cart"]["books"]).to eq([book_hash])
      end
    end

    describe "DESTROY #delete_from_cart" do
      before do
        controller.add_cart
        allow(book).to receive(:author).and_return(author)
        session["cart"]["books"] << book_hash
        xhr :delete, :delete_from_cart, {:id => valid_attributes[:id]}
      end

      it "renders template delete_from_cart" do
        expect(response).to render_template("books/delete_from_cart")
      end

      it "deletes book from session[:cart][:books]" do
        expect(session["cart"]["books"]).to eq([ ])
      end  
    end
  end

  context "loginned user access" do

    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    describe "POST #add_to_wish_list" do
      before do
        allow(user).to receive(:books).and_return([ ])
        xhr :post, :add_to_wish_list, {:id => valid_attributes[:id]}
      end

      it "renders template add_to_wish_list" do
        expect(response).to render_template("books/add_to_wish_list")
      end

      it "adds book to users books" do
        expect(controller.current_user.books.first).to eq(book)
      end
    end

    describe "DELETE #delete_from_wish_list" do
      before do
        allow(controller).to receive_message_chain("current_user.books.destroy"){true}
        allow(controller).to receive_message_chain("current_user.books.include?"){true}
      end

      it "renders template delete_from_wish_list" do
        xhr :delete, :delete_from_wish_list, {:id => valid_attributes[:id]}
        expect(response).to render_template("books/delete_from_wish_list")
      end

      it "deletes book from users books" do
        expect(controller.current_user.books).to receive(:destroy)
        xhr :delete, :delete_from_wish_list, {:id => valid_attributes[:id]}
      end
    end
  end 

  describe "#book_in_cart" do
    context "session['cart']['books'] == []" do
      it "returns false" do
        controller.add_cart
        session["cart"]["books"] = [ ]
        expect(controller.send(:book_in_cart)).to eql(false)
      end
    end
    
    context "session['cart']['books'] != [ ]" do
      before do
        controller.add_cart
        session["cart"]["books"] << book
        controller.params[:id] = book.id
      end

      it "returns books from session cart" do
        expect(controller.send(:book_in_cart)).to eql(book)
      end
    end
  end

  describe "#total price" do
    before do
      controller.add_cart
      allow(book).to receive(:author).and_return(author)
      3.times {session["cart"]["books"] << book_hash}
    end

    it "returns total price of books in cart" do
      expect(controller.send(:total_price)).to eq(3*book.price)
    end
  end

  describe "#book_to_hash" do 
    before do
      controller.add_cart
      controller.params[:id] = book.id.to_s
      allow(book).to receive(:author).and_return(author)
    end
    
    it "returns hash with short book_params from session cart" do
      expect(controller.send("book_to_hash")).to eq({ "id" => book.id,
                                                    "author"=>book.author.full_name,
                                                    "title"=> book.title,
                                                    "price"=> book.price,
                                                    "quantity" => 1
                                                  })    
    end
  end

end
