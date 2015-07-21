require 'rails_helper'



RSpec.describe ProfilesController, type: :controller do

  let(:user){FactoryGirl.create :user}
  let(:profile_attr){{user_id: user.id, email: user.email, password: user.password}}
  let(:profile){mock_model(Profile, profile_attr)}
  

  before do
    allow(controller).to receive(:current_user).and_return(user)
    #allow(profile).to receive(:user).and_return(user)
    # allow(Profile).to receive(:new).and_return(profile)
    #allow(Profile).to receive(:find).and_return(profile)
  end

  describe "GET #show" do 
    before do
      get :show
    end
    it "does something" do
     expect(assigns[:profile]).to eq(user.profile)
    end
  end

  describe "GET #edit" do
  end

  describe "POST #create" do
  end

  describe "PUT #upate" do
  end

end
