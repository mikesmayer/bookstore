require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  let(:valid_attributes){FactoryGirl.attributes_for(:book, :with_id)}
  let(:book){mock_model(Book, valid_attributes)}

  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    @ability.can :manage, :all
    allow(Book).to receive(:all).and_return([book])
    allow(Book).to receive_message_chain(:where, :all){[book]}
    allow(Book).to receive_message_chain(:filterrific_find, :paginate, :accessible_by){[book]}
    allow(Book).to receive(:new).and_return(book)
    allow(Book).to receive(:find).with(valid_attributes[:id].to_s).and_return(book)
  end

  describe "cancan negative abilities" do
    context "index" do
      context "cancan doesnt allow :index" do
        before do
          @ability.cannot :index, Book
          get :index
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'show' do
      context 'cancan doesnt allow :show' do
        before do
          @ability.cannot :show, Book
          get :show, {id: book.id}
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'new' do
      context 'cancan doesnt allow :new' do
        before do
          @ability.cannot :new, Book
          get :new
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'edit' do
      context 'cancan doesnt allow :edit' do
        before do
          @ability.cannot :edit, Book
          get :edit, {id: book.id}
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'create' do
      context 'cancan doesnt allow :create' do
        before do
          @ability.cannot :create, Book
          post :create, book: valid_attributes 
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'update' do
      context 'cancan doesnt allow :update' do
        before do
          @ability.cannot :update, Book
          put :update, {id: book.id, book: valid_attributes}
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'destroy' do
      context 'cancan doesnt allow :destroy' do
        before do
          @ability.cannot :destroy, Book
          delete :destroy, {id: book.id}
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'add_to_wish_list' do
      context 'cancan doesnt allow :add_to_wish_list' do
        before do
          @ability.cannot :add_to_wish_list, Book
          post :add_to_wish_list, {id: book.id}
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end

    context 'delete_from_wish_list' do
      context 'cancan doesnt allow :delete_from_wish_list' do
        before do
          @ability.cannot :delete_from_wish_list, Book
          delete :delete_from_wish_list, {id: book.id}
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end
  end

  describe "GET #index" do
    before do
      get :index
    end

    it "assigns all books as @books" do
      expect(assigns(:books)).to eq([book])
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end
  end

  describe "GET #show" do
    before do
      get :show, {id: book.id}
    end

    it "assigns @book to book" do
      expect(assigns[:book]).to eq(book)
    end

    it "render show template" do
      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    
    before do
      get :new
    end

    it "assigns @book to book" do
      expect(assigns[:book]).to eq(book)
    end

    it "render new template" do
      expect(response).to render_template("new")
    end
  end

  describe "GET #edit" do
    before do
      get :edit, {id: book.id}
    end

    it "assigns @book to book" do
      expect(assigns[:book]).to eq(book)
    end

    it "render edit template" do
      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do
    context "invalid params" do
      before do
        allow(book).to receive(:save).and_return(false)
        post :create, {book: valid_attributes}
      end

      it "assigns @book to book" do
        expect(assigns[:book]).to eq(book)
      end

      it "re-renders new template" do
        expect(response).to render_template('new')
      end
    end

    context "valid params" do
      before do
        allow(book).to receive(:save).and_return(true)
        post :create, {book: valid_attributes}
      end

      it "assigns @book to book" do
        expect(assigns[:book]).to eq(book)
      end

      it "redirect_to show book" do
        expect(response).to redirect_to(book_path(book))
      end

      it "sends success message" do
        expect(flash[:notice]).to eq I18n.t("success.notices.create", resource: "Book")
      end
    end

    it "receives save for book" do
      expect(book).to receive(:save)
      post :create, {book: valid_attributes}
    end
  end

  describe "PUT #update" do
    context "invalid params" do
      before do
        allow(book).to receive(:update).and_return(false)
        put :update, {id: book.id, book: valid_attributes}
      end

      it "assigns @book to book " do
        expect(assigns[:book]).to eq(book)
      end

      it "re-renders edit template" do
        expect(response).to render_template('edit')
      end
    end

    context "valid params" do
      before do
        allow(book).to receive(:update).and_return(true)
        put :update, {id: book.id, book: valid_attributes}
      end

      it "assigns @book to book " do
        expect(assigns[:book]).to eq(book)
      end

      it "redirect_to show book" do
        expect(response).to redirect_to(book_path(book))
      end

      it "sends success message" do
        expect(flash[:notice]).to eq I18n.t("success.notices.update", resource: "Book")
      end
    end

    it "receives update for book" do
      expect(book).to receive(:update)
      put :update, {id: book.id, book: valid_attributes}
    end
  end

  describe "DELETE #destroy" do
    before do
      allow(book).to receive(:destroy)
      delete :destroy, {id: book.id}
    end

    it "receives destroy for book" do
      expect(book).to receive(:destroy)
      delete :destroy, {id: book.id}
    end

    it "redirects to book_path " do
      expect(response).to redirect_to(books_path)
    end

    it "sends success message" do
      expect(flash[:notice]).to eq I18n.t("success.notices.destroy", resource: "Book")
    end
  end

  describe "POST #add_to_wish_list" do
    login_user
    before do
      allow(subject.current_user).to receive(:books).and_return([ ])
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
    login_user
    before do
      allow(subject.current_user).to receive_message_chain("books.destroy"){true}
      allow(subject.current_user).to receive_message_chain("books.include?"){true}
    end

    it "renders template delete_from_wish_list" do
      xhr :delete, :delete_from_wish_list, {:id => book.id}
      expect(response).to render_template("books/delete_from_wish_list")
    end

    it "deletes book from users books" do
      expect(subject.current_user.books).to receive(:destroy)
      xhr :delete, :delete_from_wish_list, {:id => book.id}
    end
  end
end
