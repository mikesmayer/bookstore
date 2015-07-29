Rails.application.routes.draw do

  devise_for :users, :path => '', 
             :path_names => {:sign_in => 'login', :sign_up => 'register'}, 
             :controllers => {:sessions => "devise/custom_sessions", 
             :registrations => "devise/custom_registrations" }

  resource  :profile
  resources :orders
  resources :order_steps

  resources :orders do
    resources :order_steps, controller: 'order_steps'
  end

  resources :reviews do
    member do
      put 'update_status'            =>"reviews#update_status"
    end
  end

  post       'add_to_cart/:id'       => "carts#add_to_cart",       as: "add_to_cart"
  delete     'delete_from_cart/:id'  => "carts#delete_from_cart",  as: "delete_from_cart"
  get        'cart'                  => "carts#show"

  resources :books do
    member do
      post   'add_to_wish_list'      => "books#add_to_wish_list"
      delete 'delete_from_wish_list' => "books#delete_from_wish_list"
    end

    collection do
      get    'cart'                  => "books#cart"
    end
  end
  
  resources :authors
  resources :categories
  root 'books#index'
end
