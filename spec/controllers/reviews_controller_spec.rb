require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  
  let(:review_attrs){FactoryGirl.attributes_for :review}
  let(:review){mock_model(Review, review_attrs)}
  let(:book){FactoryGirl.create :book}
  login_user

  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    @ability.can :manage, :all
    allow(Review).to receive_message_chain(:where,:all){[review]}
    allow(Review).to receive(:new).and_return(review)
    allow(Review).to receive(:find).with(review.id.to_s).and_return(review)
    allow(Book).to receive(:find).and_return(book)
    request.env["HTTP_REFERER"] = review_url(review)
  end

  describe "cancan negative abilities" do
    context "index" do
      context "cancan doesnt allow :index" do
        before do
          @ability.cannot :index, Review
          get :index
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end

    context 'show' do
      context 'cancan doesnt allow :show' do
        before do
          @ability.cannot :show, Review
          get :show, {id: review.id}
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end

    context 'edit' do
      context 'cancan doesnt allow :edit' do
        before do
          @ability.cannot :edit, Review
          get :edit, {id: review.id}
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end

    context 'create' do
      context 'cancan doesnt allow :create' do
        before do
          @ability.cannot :create, Review
          post :create, review: review_attrs 
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end

    context 'update' do
      context 'cancan doesnt allow :update' do
        before do
          @ability.cannot :update, Review
          put :update, {id: review.id, review: review_attrs}
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end

    context 'destroy' do
      context 'cancan doesnt allow :destroy' do
        before do
          @ability.cannot :destroy, Review
          delete :destroy, {id: review.id}
        end
        it{ expect(response).to redirect_to(new_user_session_path)}
      end
    end

    context 'update_status' do
      context 'cancan doesnt allow :update_status' do
        before do
          @ability.cannot :update_status, Review
          put :update_status, {id: review.id}
        end
        it{ expect(response).to render_template(file: "#{Rails.root}/public/404.html")}
      end
    end
  end

  describe "GET #index" do
    before do
      get :index
    end
      
    it "assigns all reviews as @reviews" do
      expect(assigns(:reviews)).to eq([review])
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end
  end

  describe "GET #show" do
    before do
      get :show, {id: review.id}
    end

    it "assigns @review to review" do
      expect(assigns[:review]).to eq(review)
    end

    it "render show template" do
      expect(response).to render_template("show")
    end
  end

  describe "GET #edit" do
    before do
      get :edit, {id: review.id}
    end

    it "assigns @review to review" do
      expect(assigns[:review]).to eq(review)
    end

    it "render edit template" do
      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do
    context "invalid params" do
      before do
        allow(review).to receive(:save).and_return(false)
        post :create, {review: review_attrs}
      end

      it "assigns @review to review" do
        expect(assigns[:review]).to eq(review)
      end

      it "re-renders new template" do
        expect(response).to redirect_to :back
      end
    end

    context "valid params" do
      before do
        allow(review).to receive(:save).and_return(true)
        post :create, {review: review_attrs, book_id: book.id}
      end

      it "assigns @review to review" do
        expect(assigns[:review]).to eq(review)
      end

      it "redirect_to show review" do
        expect(response).to redirect_to(book_path(book))
      end

      it "sends success message" do
        expect(flash[:notice]).to eq 'Review was successfully created.'
      end
    end

    it "receives save for review" do
      expect(review).to receive(:save)
      post :create, {review: review_attrs}
    end
  end

  describe "PUT #update" do
    context "invalid params" do
      before do
        allow(review).to receive(:update).and_return(false)
        put :update, {id: review.id, review: {raiting: 12}}
      end

      it "assigns @review to review " do
        expect(assigns[:review]).to eq(review)
      end

      it "re-renders edit template" do
        expect(response).to render_template('edit')
      end
    end

    context "valid params" do
      before do
        allow(review).to receive(:update).and_return(true)
        put :update, {id: review.id, review: review_attrs}
      end

      it "assigns @review to review " do
        expect(assigns[:review]).to eq(review)
      end

      it "redirect_to show review" do
        expect(response).to redirect_to(reviews_path)
      end

      it "sends success message" do
        expect(flash[:notice]).to eq 'Review was successfully updated.'
      end
    end

    it "receives update for review" do
      expect(review).to receive(:update)
      put :update, {id: review.id, review: {raiting: 12}}
    end
  end

  describe "DELETE #destroy" do
    before do
      allow(review).to receive(:destroy)
      delete :destroy, {id: review.id}
    end

    it "receives destroy for review" do
      expect(review).to receive(:destroy)
      delete :destroy, {id: review.id}
    end

    it "redirects to reviews_path " do
      expect(response).to redirect_to(reviews_path)
    end

    it "sends success message" do
      expect(flash[:notice]).to eq 'Review was successfully destroyed.'
    end
  end

  describe "PUT #update_status" do
    before do
      allow(review).to receive(:update).and_return(true)
      put :update_status, {id: review.id, review: review_attrs}
    end

    it "assigns @review to review" do
      expect(assigns[:review]).to eq(review)
    end

    it "render update_status template" do
      expect(response).to redirect_to :back
    end

    it "receives update_status for review" do
      expect(review).to receive(:update)
      put :update_status, {id: review.id, review: review_attrs}
    end
  end
end
