Rails.application.routes.draw do

  devise_for :users, :path => '', 
             :path_names => {:sign_in => 'login', :sign_up => 'register'}, 
             :controllers => {:sessions => "devise/custom_sessions", 
             :registrations => "devise/custom_registrations" }

  resource  :profile
  resources :orders
  resources :reviews do
    member do
      put 'update_status' =>"reviews#update_status"
    end
  end

  resources :books do
    member do
      post   'add_to_cart'            => "books#add_to_cart"
      delete 'delete_from_cart'       => "books#delete_from_cart"
      post   'add_to_wish_list'       => "books#add_to_wish_list"
      delete 'delete_from_wish_list'  => "books#delete_from_wish_list"
    end

    collection do
      get    'cart'                   => "books#cart"
    end
  end
  
  resources :authors
  resources :categories
  root 'books#index'

  # get "admin/dashboard" => "pages#dashboard"
end
