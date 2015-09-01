class RouteAccessErrors
  include Service

  LOGINERROR = {"Order"  => [:index, :show, :update, :cart, :add_to_cart, :delete_from_cart, :cancel],
                "Review" => [:show, :edit, :create, :update, :destroy],
                "Book"   => [:add_to_wish_list, :delete_from_wish_list]}

  def initialize(error)
    @error   = error

    if cancan_error?
      @subject = error.subject.class.to_s 
      @action  = error.action
    end
    @subject = error.subject.to_s if @action == :index
  end

  def call
    login_error?
  end

  private

  def cancan_error?
    if @error.is_a? CanCan::AccessDenied
      true
    else
      false
    end
  end

  def login_error?
    if LOGINERROR.has_key? @subject
      LOGINERROR[@subject].include? @action
    else
      false
    end
  end
end