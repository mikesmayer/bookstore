Rails.application.routes.draw do

  get 'pages/home'

  devise_for  :users, :path => '', 
              :path_names  => {:sign_in => 'login', :sign_up => 'register'}, 
              :controllers => {:sessions => "devise/custom_sessions", 
                               :registrations => "devise/custom_registrations",
                               :omniauth_callbacks => "devise/custom_omniauth_callbacks" }

  resource    :profile do
    member do
      get 'wishlist'                => "profiles#wishlist"
    end
  end

  resources   :orders 
  resources   :authors
  resources   :categories

  resources   :orders do
    resources :order_steps, controller: 'order_steps'

    member do
      post       'add_to_cart'       => "orders#add_to_cart",       as: "add_to_cart_book"
      delete     'delete_from_cart'  => "orders#delete_from_cart",  as: "delete_from_cart_book"
      post       'cancel'            => "orders#cancel",            as: "cancel"
    end
  end

  get      'cart/:id'                => "orders#cart",              as: "cart"

  resources   :reviews do
    member do
      put 'update_status'            =>"reviews#update_status"    
    end
  end

  resources   :books do
    member do
      post   'add_to_wish_list'      => "books#add_to_wish_list"
      delete 'delete_from_wish_list' => "books#delete_from_wish_list"
    end
  end

  get "shop"                        => "books#index",             as: "shop"
  
  root 'pages#home'

  scope :api do
    scope :v1 do
      resources :projects, except: [:new, :edit] do
        resources :tasks, except: [:new, :edit], shallow: true do
          resources :comments, except: [:new, :edit], shallow: true do
            resources :attached_files, except: [:new, :edit], shallow: true
          end
        end
      end
    end
  end
end
