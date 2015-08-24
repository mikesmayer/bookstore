class ProfilesController < ApplicationController
  before_action :build_profile
  authorize_resource :profile
  before_action :build_profile_form, only: [:edit, :update]

  def wishilist
  end

  def show
  end

  def edit
  end
  
  def update
    if @profile_form.submit(profile_params) 
      redirect_to profile_path, notice: t("success.notices.update", resource: "Profile")
    else
      render :edit
    end
  end

  private
  
  def profile_params
    params.require(:profile_form).permit!#(:shipping_addres, :password)
  end

  def build_profile_form
    @profile_form = ProfileForm.new(@profile)
  end

  def build_profile
    @profile = current_user.profile if current_user
  end
end
