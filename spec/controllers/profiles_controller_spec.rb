require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  
  let(:shipping_address_attr){FactoryGirl.attributes_for :address, :with_country_attrs}
  let(:billing_address_attr) {FactoryGirl.attributes_for :address, :with_country_attrs}
  let(:credit_card_attr){FactoryGirl.attributes_for :credit_card}
  let(:profile_invalid_attrs){{credit_card_attributes: {}}}
  let(:profile_valid_attrs){{credit_card_attributes: credit_card_attr, 
                             billing_address_attributes: billing_address_attr, 
                             shipping_address_attributes: shipping_address_attr}}
  let(:profile){mock_model(Profile)}
  login_user

  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    @ability.can :manage, :all
  end

  describe "cancan negative abilities" do
    context '#show' do
      context 'cancan doesnt allow :show' do
        before do
          @ability.cannot :show, Profile
          get :show
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context '#edit' do
      context 'cancan doesnt allow :edit' do
        before do
          @ability.cannot :edit, Profile
          get :edit
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context '#edit' do
      context 'cancan doesnt allow :edit' do
        before do
          @ability.cannot :edit, Profile
          get :edit
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context '#update' do
      context 'cancan doesnt allow :update' do
        before do
          @ability.cannot :update, Profile
          put :update
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end
  end
  
  describe "GET #show" do 
    before do
      get :show
    end

    it "assigns @profile to current_user.profile" do
      expect(assigns[:profile]).to eq(subject.current_user.profile)
    end

    it "render show template" do
      expect(response).to render_template("show")
    end
  end

  describe "GET #edit" do
    before do
      get :edit
    end

    it "assigns @profile to current_user.profile" do
      expect(assigns[:profile]).to eq(subject.current_user.profile)
    end

    it "renders new template" do
      expect(response).to render_template('edit')
    end
  end

  describe "PUT #upate" do
    context "invalid params" do
      before do
        allow(profile).to receive(:update).and_return(false)
        put :update, { profile: profile_invalid_attrs}
      end

      it "receives update for profile" do
        expect(subject.current_user.profile).to receive(:update)
        put :update, profile: profile_invalid_attrs
      end

      it "re-renders edit form " do
        expect(response).to render_template('edit')
      end
    end

    context "valid params" do
      before do
        allow(profile).to receive(:update).and_return(true)
        put :update, { profile: {credit_card_attributes: credit_card_attr, 
                             billing_address_attributes: billing_address_attr, 
                             shipping_address_attributes: shipping_address_attr}}
      end

      it "assigns @profile" do
        expect(assigns[:profile]).to eql(subject.current_user.profile)
      end

      it "receives update for @profile" do
        expect(subject.current_user.profile).to receive(:update)
        put :update, profile: profile_valid_attrs
      end

      it "redirect_to profile_path" do
        expect(response).to redirect_to(profile_path)
      end

      it "sends success notice" do
        expect(flash[:notice]).to eq 'Profile was successfully updated.'
      end
    end
  end
end
