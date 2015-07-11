class Devise::CustomSessionsController  < Devise::SessionsController
  before_filter :before_destroy, :only => :destroy
  after_filter  :after_destroy, :only => :destroy
  # after_filter :after_destroy, :only => :destroy

  # # def before_login
  # # end

  # def after_login
  #   @cart = Cart.new
    
  #   # @cart.add_book(Book.first)
  #   # @cart.add_book(Book.first)
  #   session[:cart] = @cart#put_in_session(@cart)
  # end

  def before_destroy
    @cart = session[:cart]
  end

   def after_destroy
     session[:cart] = @cart
   end

end
