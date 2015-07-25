require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:shipping_address_attr){FactoryGirl.attributes_for :address, :with_country_attrs}
  let(:billing_address_attr){FactoryGirl.attributes_for  :address, :with_country_attrs }
  let(:credit_card_attr){FactoryGirl.attributes_for :credit_card}
  let(:order_attr){FactoryGirl.attributes_for :order}
  let(:order){mock_model(Order, order_attr)}
  
  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    @ability.can :manage, :all
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

    context 'new' do
      context 'cancan doesnt allow :new' do
        before do
          @ability.cannot :new, Order
          get :new
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end

    context 'edit' do
      context 'cancan doesnt allow :edit' do
        before do
          @ability.cannot :edit, Order
          get :edit, {id: order.id}
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end

    context 'create' do
      context 'cancan doesnt allow :create' do
        before do
          @ability.cannot :create, Order
          post :create, order: order_attr 
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

    context 'destroy' do
      context 'cancan doesnt allow :destroy' do
        before do
          @ability.cannot :destroy, Order
          delete :destroy, {id: order.id}
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
      get :show, {id: order.id}
    end

    it "assigns @order to order" do
      expect(assigns[:order]).to eq(order)
    end

    it "render show template" do
      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    before do
      allow(order).to receive(:current_step=)
      allow(subject).to receive(:build_order)
      session["cart"]= {"books" => ["test"]}
      get :new
    end

    it "sets session[:orders_params] to {} if it nil" do
      expect(session["order_params"]).to eq({})
    end

    it "assigns @order to order" do
      expect(assigns[:order]).to eq(order)
    end

    it "call #build_order" do
      expect(subject).to receive(:build_order)
      get :new
    end

    it "call on @order #current_step with session('order_step')" do
      session["order_step"] = "shipping"
      expect(order).to receive(:current_step=).with(session["order_step"])
      get :new
    end

    it "render new template" do
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do

    before do
      allow(order).to receive(:current_step=)
      session["order_params"] = {}
      session["cart"]= {"books" => ["test"]}

      allow(order).to receive(:next_step)
      allow(controller).to receive(:build_order)
    end

    context "filling out orders information" do
      before do
        session["order_step"] = "shipping"
        allow(order).to receive(:current_step).and_return("shipping")
        allow(order).to receive(:last_step?).and_return(false)
        allow(order).to receive(:new_record?).and_return(true)
      end

      it "writes orders params to session" do
        order_params = {order: {shipping_address_attributes: shipping_address_attr}}
        post :create, order_params
        expect(session["order_params"]).not_to be_empty
      end

      it "assigns @order to order" do
        post :create, session["order_params"]
        expect(assigns[:order]).to eq(order)
      end

      it "calls #current_step on order" do
        expect(order).to receive(:current_step)
        post :create
      end

      it "renders new template" do
        post :create
        expect(response).to render_template('new')
      end

      context "valid params" do
        before do
          allow(controller).to receive(:step_valid?).and_return(true)
        end

        it "calls #next_step on order" do
          expect(order).to receive(:next_step)
          post :create
        end
      end

      context "invalid params" do
        before do
          allow(controller).to receive(:step_valid?).and_return(false)
        end

        it "doesn't call #next_step on order" do
          expect(order).not_to receive(:next_step)
          post :create
        end
      end
    end

    context "confirmation step" do
      login_user
      before do
        allow(subject).to receive(:step_valid?).and_return(true)
        allow(order).to receive(:user_id=)
        allow(order).to receive(:save).and_return(true)
        session["order_step"] = "confirmation"
        allow(order).to receive(:ordered_books=)
        allow(order).to receive(:current_step).and_return("confirmation")
        allow(order).to receive(:last_step?).and_return(true)
        allow(order).to receive(:new_record?).and_return(false)
        allow(subject).to receive(:order_params).and_return({})
      end

      it "calls on order #last_step?" do
        expect(order).to receive(:last_step?)
        post :create, {}
      end

      it "sets order.user_id to current_user.id" do
        expect(order).to receive(:user_id=).with(subject.current_user.id)
        post :create, {}
      end

      it "sets order.ordered_books to session['cart']['books']" do
        expect(order).to receive(:ordered_books=).with(session['cart']['books'])
        post :create, {}
      end

      it "calls on order #save" do
        expect(order).to receive(:save)
        post :create, {}
      end

      it "sets session['order_step'] to 'confirmation'" do
        expect(session['order_step']).to eq("confirmation")
      end

      it "redirects to order_path" do
        post :create, {}
        expect(response).to redirect_to(order_path(order))
      end
    end
  end

  describe "PUT #update" do
    context "invalid params" do
      before do
        allow(order).to receive(:update).and_return(false)
        put :update, {id: order.id}
      end

      it "assigns @order to order " do
        expect(assigns[:order]).to eq(order)
      end

      it "re-renders edit template" do
        expect(response).to render_template('edit')
      end
    end

    context "valid params" do
      before do
        allow(order).to receive(:update).and_return(true)
        put :update, {id: order.id, order: order_attr}
      end

      it "assigns @order to order " do
        expect(assigns[:order]).to eq(order)
      end

      it "redirect_to show order" do
        expect(response).to redirect_to(order_path(order))
      end

      it "sends success message" do
        expect(flash[:notice]).to eq 'Order was successfully updated.'
      end
    end

    it "receives update for order" do
      expect(order).to receive(:update)
      put :update, {id: order.id}
    end
  end

  describe "DELETE #destroy" do
    before do
      allow(order).to receive(:destroy)
      delete :destroy, {id: order.id}
    end

    it "receives destroy for order" do
      expect(order).to receive(:destroy)
      delete :destroy, {id: order.id}
    end

    it "redirects to orders_path " do
      expect(response).to redirect_to(orders_path)
    end

    it "sends success message" do
      expect(flash[:notice]).to eq 'Order was successfully destroyed.'
    end
  end

  describe "#step_valid?" do
    context "shipping address step" do
      before do
        allow(order).to receive(:current_step).and_return("shipping")
        allow(order).to receive(:credit_card).and_return(CreditCard.create(credit_card_attr))
        subject.instance_variable_set(:@order, order)
      end

      context "shipping address valid" do
        it "returns true" do
          allow(order).to receive_message_chain(:shipping_address, :valid?){true}
          expect(subject.send(:step_valid?)).to eq(true)
        end
      end

      context "shipping address invalid" do
        it "returns false" do
          allow(order).to receive_message_chain(:shipping_address, :valid?){false}
          expect(subject.send(:step_valid?)).to eq(false)
        end
      end
    end

    context "billing address step" do
      before do
        allow(order).to receive(:current_step).and_return("billing")
        subject.instance_variable_set(:@order, order)
      end

      context "billing address valid" do
        it "returns true" do
          allow(order).to receive_message_chain(:billing_address, :valid?){true}
          expect(subject.send(:step_valid?)).to eq(true)
        end
      end

      context "billing address invalid" do
        it "returns false" do
          allow(order).to receive_message_chain(:billing_address, :valid?){false}
          expect(subject.send(:step_valid?)).to eq(false)
        end
      end
    end

    context "paying step" do
      before do
        allow(order).to receive(:current_step).and_return("paying")
        subject.instance_variable_set(:@order, order)
      end

      context "credit_card valid" do
        it "returns true" do
          allow(order).to receive_message_chain(:credit_card, :valid?){true}
          expect(subject.send(:step_valid?)).to eq(true)
        end
      end

      context "credit_card invalid" do
        it "returns false" do
          allow(order).to receive_message_chain(:credit_card, :valid?){false}
          expect(subject.send(:step_valid?)).to eq(false)
        end
      end
    end
  end
end
