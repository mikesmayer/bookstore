class Ability
    
  include CanCan::Ability

  def initialize(user)

    user ||= User.new 

    if user.role? "admin" 
      can :manage, :all
    
    elsif user.role? "customer"
      can :read, Author
      can [:read, :add_to_wish_list, :delete_from_wish_list, 
           :add_to_cart, :delete_frome_cart, :cart], Book
      can :read, Category
      can :manage, Profile, user_id: user.id
      can :manage, Order#,   user_id: user.id
      can :manage, Review
      cannot :index, Review
      cannot :update_status, Review

    else
      can [:read], [Author, Book, Category, Review]
      cannot :index, Review
      can [:add_to_cart, :delete_frome_cart, :cart], Book
    end
  end
end