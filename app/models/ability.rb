class Ability
    
  include CanCan::Ability

  def initialize(user, session)

    user ||= User.new(session: session["temp_order"])

    if user.role? "admin" 
      can :manage, :all
    
    elsif user.role? "customer"
      can    :read, Author
      cannot :index, Author
      can [:read, :add_to_wish_list, :delete_from_wish_list, 
           :add_to_cart, :delete_from_cart, :cart], Book
      cannot :index, Book, quantity: 0
      can :read, Category
      cannot :index, Category
      can :manage, Profile, user_id: user.id
      can :manage, Order,   user_id: user.id
      can :add_to_cart, Order, user_id: user.id
      can :manage, Review,  user_id: user.id
      cannot :index, Review
      cannot :update_status, Review

    else
      can [:cart, :update], Order, session_id: user.session, status: "initializing"
      can [:read],    [Author, Book, Category, Review]
      cannot :index, [Author, Category, Review]
      can [:add_to_cart, :delete_from_cart, :cart], Book
      cannot :index, Book, quantity: 0
    end
  end
end