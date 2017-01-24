Rails.application.routes.draw do


  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do

      resources :push_notifications do
        collection do
          post :register_device
        end
      end

    end
  end


  post 'auth/verify_by_token' => 'omniauth_verifications#verify_token_token'
  

  devise_for :users, :controllers => { sessions: 'sessions', :omniauth_callbacks => "omniauth_callbacks", registrations: 'registrations'  }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get '/unsubscribe' => 'home#unsubscribe'
  get '/user_confirm' => 'home#user_confirm'
  default_url_options :host => "colearn.xyz"

  resources :posts do
    member do
      post 'close'
      get 'fetch_chat_info'
      post 'suggestion'
    end
    resources :comments
    resources :votes
    resources :chats do
      member do
        get 'resource_download_url'
      end
    end
    resources :invites
    collection do
      get 'search'
    end
  end
  resources :topics
      
  resources :suggestion do
    resources :votes
  end

  post 'feedback' => 'home#feedback'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
