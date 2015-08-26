require 'rails_helper'

RSpec.describe OrderStepsController, type: :controller do

  
  let(:order_valid_attr){FactoryGirl.attributes_for :order}
  let(:order){mock_model(Order, order_valid_attr)}
  let!(:order_form){OrderForm.new(order)}

  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    @ability.can :manage, :all
    allow(order).to receive(:save).and_return(true)
    allow(order).to receive(:id).and_return(1)
    allow(OrderForm).to receive(:new).and_return(order_form)
  end

  describe "cancan negative abilities" do
    context "show" do
      context "cancan doesnt allow :show" do
        before do
          @ability.cannot :show, Order
          get :show, {order_id: order.id, id: "address"}
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end

    context "update" do
      context "cancan doesnt allow :update" do
        before do
          @ability.cannot :update, Order
          put :update, order_id: order.id, id: "address"
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end
  end

  describe "GET #show" do
    context "current step" do
        before do
          allow(subject).to receive(:steps).and_return([:address, :delivery, :payment, :confirm])
        end

      context "address" do
        it "renders address template" do
          get :show, {order_id: order.id, id: "address"}
          expect(response).to render_template('address')
        end
      end

      context "delivery" do
        it "renders delivery template" do
          get :show, {order_id: order.id, id: "delivery"}
          expect(response).to render_template('delivery')
        end
      end

      context "payment" do
        it "renders payment template" do
          get :show, {order_id: order.id, id: "payment"}
          expect(response).to render_template('payment')
        end
      end

      context "confirmation" do
        it "renders confirmation template" do
          get :show, {order_id: order.id, id: "confirm"}
          expect(response).to render_template('confirm')
        end
      end
    end

    before do
      get :show, {order_id: order.id, id: "address"}
    end

    it "assigns @order to order" do
      expect(assigns[:order]).to eq(order)
    end
  end

  describe "PUT #update" do
    context "invalid params" do
      before do
        allow(subject).to receive(:steps).and_return([:address, :delivery, :payment, :confirmation])
        allow(order_form).to receive(:update).and_return(false)
        allow(order_form).to receive(:save).and_return(false)
        put :update, {order_id: order.id, id: "address", order_form: {shipping_address: {first_name: "test"}}}
      end

      it "assigns @order to order " do
        expect(assigns[:order]).to eq(order)
      end

      it "re-renders previous step template" do
        expect(response).to render_template('address')
      end
    end

    context "valid params" do
      before do
        allow(subject).to receive(:steps).and_return([:address, :delivery, :payment, :confirmation])
        allow(order_form).to receive(:update).and_return(true)
        allow(order_form).to receive(:save).and_return(true)
        put :update, {order_id: order.id, id: 'address'}
      end

      it "assigns @order to order " do
        expect(assigns[:order]).to eq(order)
      end

      it "redirect_to next step" do
        expect(response).to redirect_to("#{root_url}orders/#{order.id}/order_steps/delivery")
      end
    end

    it "receives update for order" do
      expect(order_form).to receive(:update)
      put :update, {order_id: order.id, id: 'address'}
    end
  end

  describe "#build_order_form" do
    it{ expect(subject.send :build_order_form).to eq(order_form)}
  end

  describe "#set_steps" do
    before do
      subject.instance_variable_set :@order, order
      allow(order).to receive(:available_steps)
    end

    it "calls #available_steps on @order" do
      expect(order).to receive(:available_steps)
      subject.send :set_steps
    end
  end

  describe "#finish_wizard_path" do
    before do
      subject.instance_variable_set :@order, order
      allow(subject).to receive_message_chain(:current_user, :id)
      allow(order).to receive(:set_in_process!)
      allow(order).to receive(:create).and_return(order)
    end

    it "calls #set_in_process! on @order" do
      expect(order).to receive(:set_in_process!)
      subject.send :finish_wizard_path
    end

    it "creates new Order" do
      expect(Order).to receive(:create)
      subject.send :finish_wizard_path
    end

    it "returns orders_path" do
      expect(subject.send :finish_wizard_path).to eq orders_path
    end
  end
end
