require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  login_user
  let(:shipping_address_attr){FactoryGirl.attributes_for :address, :with_country_attrs}
  let(:billing_address_attr) {FactoryGirl.attributes_for :address, :with_country_attrs}
  let(:credit_card_attr){FactoryGirl.attributes_for :credit_card}
  let(:profile_valid_attrs){{credit_card: credit_card_attr, 
                             billing_address: billing_address_attr, 
                             shipping_address: shipping_address_attr}}
  let(:profile){mock_model(Profile, profile_valid_attrs)}
  let(:profile_form){ProfileForm.new(profile)}

  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    @ability.can :manage, :all
    allow(subject.current_user).to receive(:profile).and_return(profile)
    allow(ProfileForm).to receive(:new).and_return(profile_form)
  end

  describe "cancan negative abilities" do
    context '#wishlist' do
      context 'cancan doesnt allow :wishlist' do
        before do
          @ability.cannot :wishlist, Profile
          get :wishlist
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

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

  describe "GET #wishlist" do
    it "renders wishlist template" do
      get :wishlist
      expect(response).to render_template("wishlist")
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
        allow(profile_form).to receive(:submit).and_return(false)
        put :update, profile_form: profile_valid_attrs
      end

      it "calls #submit on @profile_form" do
        expect(profile_form).to receive(:submit)
        put :update, {profile_form: profile_valid_attrs}
      end

      it "re-renders edit form " do
        expect(response).to render_template('edit')
      end
    end

    context "valid params" do
      before do
        allow(profile_form).to receive(:submit).and_return(true)
        put :update, { profile_form: profile_valid_attrs }
      end

      it "assigns @profile" do
        expect(assigns[:profile]).to eql(subject.current_user.profile)
      end

      it "receives update for @profile" do
        expect(profile_form).to receive(:submit)
        put :update, profile_form: profile_valid_attrs
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
