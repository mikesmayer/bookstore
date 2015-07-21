class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  #load_and_authorize_resource

  def show
  end

  def edit
  end
  
  def update
    respond_to do |format|
      if @profile.update(profile_params) 
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    
  def set_profile
    @profile = Profile.find(current_user.id)#current_user.profile
    @profile.shipping_address || @profile.build_shipping_address
    @profile.billing_address  || @profile.build_billing_address
    @profile.credit_card      || @profile.build_credit_card
    @profile.shipping_address.country || @profile.shipping_address.build_country
    @profile.billing_address.country || @profile.billing_address.build_country
  end

    
    def profile_params
      params.require(:profile).permit!
    end
end
