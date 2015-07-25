class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  

  rescue_from CanCan::AccessDenied do |exception|
    if exception.action == :index
      subject = exception.subject
      if (subject == Review) || (subject == Category) || (subject == Book) || (subject==Author)
        render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
      else
        redirect_to new_user_session_path
      end
    else
      if (exception.subject.kind_of? Review) && (exception.action != :update_status)
        redirect_to new_user_session_path
      elsif exception.subject.kind_of? Order
        redirect_to new_user_session_path
      else
        render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
      end
    end
  end

  def check_permissions
    user = current_user || User.new
    unless user.role? "admin"
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
    end
  end

  def book_filterrific
    @filterrific = initialize_filterrific(
      Book,
      params[:filterrific],
      :select_options => {
        with_category_id: Category.options_for_select
      }
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
