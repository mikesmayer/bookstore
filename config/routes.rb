Rails.application.routes.draw do

  devise_for :users, :path => '', 
             :path_names => {:sign_in => 'login', :sign_up => 'register'}, 
             :controllers => {:sessions => "devise/custom_sessions", 
             :registrations => "devise/custom_registrations" }

  resource  :profile
  resources :orders 
  get "cart/:id"                    => "orders#cart",            as: "cart"

  resources :orders do
    resources :order_steps, controller: 'order_steps'

    member do
      post       'add_to_cart'       => "orders#add_to_cart"
      delete     'delete_from_cart'  => "orders#delete_from_cart"
    end
  end

  resources :reviews do
    member do
      put 'update_status'            =>"reviews#update_status"    
    end
  end

  # post       'add_to_cart/:id'       => "carts#add_to_cart",       as: "add_to_cart"
  # delete     'delete_from_cart/:id'  => "carts#delete_from_cart",  as: "delete_from_cart"
  #get        'cart'                  => "carts#show"

  resources :books do
    member do
      post   'add_to_wish_list'      => "books#add_to_wish_list"
      delete 'delete_from_wish_list' => "books#delete_from_wish_list"
      post   'add_to_cart'           => "books#add_to_cart"
      delete 'delete_from_cart'      => "books#delete_from_cart"

    end

    # collection do
    #   get    'cart'                  => "books#cart"
    # end
  end
  
  resources :authors
  resources :categories
  root 'books#index'
end
