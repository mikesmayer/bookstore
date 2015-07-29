class ProfilesController < ApplicationController
  include ResourceBuilder
  before_action :build_profile, only: [:show, :edit, :update]
  authorize_resource :profile
  respond_to :html

  def show
  end

  def edit
  end
  
  def update
      if @profile.update(profile_params)
        flash[:notice] = 'Profile was successfully updated.'
        redirect_to profile_path
      else
        respond_with(@profile, action: "edit")
      end
  end

  private
  
  def profile_params
    params.require(:profile).permit!#(:email, :password)
  end
end
