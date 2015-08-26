require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:order_attr){FactoryGirl.attributes_for :order}
  let(:order){mock_model(Order, order_attr)}
  let(:book){FactoryGirl.create :book}
  
  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    @ability.can :manage, :all
    allow(order).to receive(:save)
    allow(Order).to receive_message_chain(:accessible_by,:all){[order]}
    allow(Order).to receive(:new).and_return(order)
    allow(Order).to receive(:find).with(order.id.to_s).and_return(order)
  end

  describe "cancan negative abilities" do
    context "index" do
      context "cancan doesnt allow :index" do
        before do
          @ability.cannot :index, Order
          get :index
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end
    
    context 'show' do
      context 'cancan doesnt allow :show' do
        before do
          @ability.cannot :show, Order
          get :show, {id: order.id}
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end

    context 'update' do
      context 'cancan doesnt allow :update' do
        before do
          @ability.cannot :update, Order
          put :update, {id: order.id, order: order_attr}
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end

    context 'cart' do
      context 'cancan doesnt allow :cart' do
        before do
          @ability.cannot :cart, Order
          get :cart, id: order.id
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end

    context 'add_to_cart' do
      context 'cancan doesnt allow :add_to_cart' do
        before do
          @ability.cannot :add_to_cart, Order
          post :add_to_cart, id: order.id, book_id: 1
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end

    context 'delete_from_cart' do
      context 'cancan doesnt allow :delete_from_cart' do
        before do
          @ability.cannot :delete_from_cart, Order
          delete :delete_from_cart, id: order.id
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end

    context 'cancel' do
      context 'cancan doesnt allow :cancel' do
        before do
          @ability.cannot :cancel, Order
          post :cancel, id: order.id
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end
  end

  describe "GET #index" do
    before do
      get :index
    end
 
    it "assigns orders collection as @orders" do
      expect(assigns(:orders)).to eq([order])
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end

    it "call on Order accessible_by scope" do
      expect(Order).to receive(:accessible_by)
      get :index
    end
  end

  describe "GET #show" do
    before do
      get :show, id: order.id 
    end

    it "assigns @order to order" do
      expect(assigns[:order]).to eq(order)
    end

    it "render show template" do
      expect(response).to render_template("show")
    end
  end

  describe "PUT #update" do
    before do
      request.env["HTTP_REFERER"] = cart_url(order)
      allow(order).to receive(:flash_notice)
    end

    context "valid params" do
      before do
        allow(order).to receive(:update).and_return(true)
      end
      context "empty_cart" do
        before do
          allow(order).to receive_message_chain(:order_books, :destroy_all)
        end

        it "deletes books from order" do
          expect(order).to receive_message_chain(:order_books, :destroy_all)
          put :update, id: order.id, button: "empty_cart"
        end
      end

      it "calls update on order" do
        expect(order).to receive(:update)
        put :update, id: order.id
      end

      it "redirects to :back" do
        put :update, id: order.id
        expect(response).to redirect_to :back
      end
    end

    context "invalid params" do
      before do
        allow(order).to receive(:update).and_return(false)
        allow(order).to receive_message_chain(:errors, :messages){"flash_errors"}
      end

      it "redirects to :back" do
        put :update, id: order.id
        expect(response).to redirect_to :back
      end

      it "calls #update on @order" do
        expect(order).to receive(:update)
        put :update, id: order.id
      end

      it "sets flash[:errors] to @order.erros.messages" do
        put :update, id: order.id
        expect(flash[:errors]).to eq(order.errors.messages)
      end
    end
  end

  describe "GET #cart" do
    before do
      get :cart, id: order.id
    end

    it "assigns @order to order" do
      expect(assigns[:order]).to eq(order)
    end

    it "render show template" do
      expect(response).to render_template("cart")
    end
  end

  describe "POST #add_to_cart" do
    before do
      allow(order).to receive(:add_book)
      xhr :post, :add_to_cart, id: order.id, book_id: book.id
    end

    it "renders add_to_cart template" do
      expect(response).to render_template("orders/add_to_cart")
    end

    it "assigns @order with order" do
      expect(assigns[:order]).to eq(order)
    end

    it "assigns @book with book" do
      expect(assigns[:book]).to eq(book)
    end

    it "calls on @order #add_book" do
      expect(order).to receive(:add_book)
      xhr :post, :add_to_cart, id: order.id, book_id: book.id
    end
  end

  describe "DELETE #delete_from_cart" do
    before do
      request.env["HTTP_REFERER"] = cart_url(order)
      allow(order).to receive(:delete_book)
    end

    it "calls #delete_book on @order" do
      expect(order).to receive(:delete_book)
      delete :delete_from_cart, id: order.id, book_id: book.id
    end

    it "redirects to :back" do
      delete :delete_from_cart, id: order.id, book_id: book.id
      expect(response).to redirect_to :back
    end
  end

  describe "POST #cancel" do
    before do
      request.env["HTTP_REFERER"] = cart_url(order)
      allow(order).to receive(:cancel!)
    end

    it "calls #cancel! on order" do
      expect(order).to receive(:cancel!)
      post :cancel, id: order.id
    end

    it "redirects to :back" do
      post :cancel, id: order.id
      expect(response).to redirect_to :back
    end
  end
end
