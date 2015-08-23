class ProfilesController < ApplicationController
  include ResourceBuilder
  before_action :build_profile, only: [:show, :edit, :update]
  authorize_resource :profile

  def wishilist
  end

  def show
  end

  def edit
  end
  
  def update
    if @profile.update(profile_params) 
      redirect_to profile_path, notice: t("success.notices.update", resource: "Profile")
    else
      render :edit
    end
  end

  private
  
  def profile_params
    params.require(:profile).permit!#(:email, :password)
  end
end
