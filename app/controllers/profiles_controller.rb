class ProfilesController < ApplicationController
  include ResourceBuilder
  before_action :build_profile, only: [:show, :edit, :update]
  authorize_resource :profile

  def show
  end

  def edit
  end
  
  def update
    respond_to do |format|
      if @profile.update(profile_params) 
        format.html { redirect_to profile_path, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  
  def profile_params
    params.require(:profile).permit!#(:email, :password)
  end
end
