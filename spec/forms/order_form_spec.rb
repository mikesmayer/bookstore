require 'rails_helper'

describe OrderForm do
  let(:country){FactoryGirl.create :country}
  let(:shipping_address_attr){FactoryGirl.attributes_for :address}
  let(:billing_address_attr){FactoryGirl.attributes_for :address}
  let(:credit_card_attr){FactoryGirl.attributes_for :credit_card}
  let(:delivery){FactoryGirl.create :delivery}
  let(:profile){FactoryGirl.create :profile}
  let(:order){FactoryGirl.create :order, shipping_address_id: nil, billing_address_id: nil}
  let(:order_form){OrderForm.new(order)}


  describe "#update" do
    context 'address presented' do
      it "updates address params" do
        params = {shipping_address: shipping_address_attr, billing_address: {}, billing_equal_shipping: "1"}
        order_form.update(params)
        expect(order.shipping_address.first_name).to eq shipping_address_attr[:first_name]
      end
    end

    context 'delivery presented' do
      it "updates delivery params" do
        params = {delivery: {delivery_id: delivery.id.to_s}}
        order_form.update(params)
        expect(order.delivery_id).to eq delivery.id
      end
    end

    context 'credit_card presented' do
      it "updates delivery params" do
        params = {credit_card: credit_card_attr}
        order_form.update(params)
        expect(order.credit_card.number).to eq credit_card_attr[:number]
      end
    end
  end

  describe "#save" do
    it "saves order" do
      expect(order_form.save).to eq true
    end
  end

  
end