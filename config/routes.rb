Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  resources :products do
    resources :reviews, only: [:new, :create]
  end

  get '/login'  =>  'sessions#new', as: 'login'
  post '/login' =>  'sessions#create'
  delete '/logout' => 'sessions#destroy', as: 'logout'
  resources :merchants, only: [:new, :create, :show] do
    get :dashboard
    resources :products
    resources :orders, only: [:index, :show]
  end

  resources :categories, only: [:new, :create, :show]

  resources :orders, only: [:edit, :update, :show] do
    get :confirmation
    get :shipping_address_form
    post :shipping_estimates
    get :select_shipping_method
  end

  get 'merchant/:merchant_id/orders/shipped' => 'orders#shipped', as: "orders_shipped"
  get 'merchant/:merchant_id/orders/unshipped' => 'orders#unshipped', as: "orders_unshipped"

  patch 'merchants/:merchant_id/products/:id/active_update' => 'products#active_update', as: "active_update"

  patch 'merchants/:merchant_id/order_items/:id' => 'order_items#mark_shipped', as: "mark_shipped"

  get '/cart'             =>  'carts#show'
  post '/add_to_cart/:id' =>  'carts#add_to_cart', as: 'add_to_cart'
  resources :order_items

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
