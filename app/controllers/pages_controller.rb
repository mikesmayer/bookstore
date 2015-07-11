class PagesController < ApplicationController

 # before_filter :check_permissions, :only => [:dashboard]

  def home

  end

  def dashboard

    
    
  end

  def add_item
    render text: "item is added"
  end

  def check_permissions
    authorize! :dashboard, @user
  end


end
