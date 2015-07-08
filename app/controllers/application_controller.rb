class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  def check_permissions
    user = current_user || User.new

   #authorize! :new, :edit, :create, :update, :destroy, current_user
    unless user.role? "admin"
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
    end
  end

  def author_book_filterrific
    @author = Author.new
    @filterrific = initialize_filterrific(
      Author,
      params[:filterrific]
    ) or return
    
  end

  # def after_sign_in_path_for(resourse)

  #   if  current_user.role? "admin"
  #     admin_books_path
  #   else
  #     root_path
  #   end

  # end

  

end
