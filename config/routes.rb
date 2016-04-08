Rails.application.routes.draw do

  post 'products/list_products' => 'products#list_products', :as => "list_product"
  post 'products/list_flights' => 'products#list_flights', :as => "list_flights"
  post 'products/list_countries' => 'products#list_countries', :as => "list_countries"
  post 'products/get_hotels' => 'products#get_hotels', :as => "get_hotels"
  post 'products/get_min_price_flights' => 'products#get_min_price_flights', :as => "get_min_price_flights"
  post 'products/go_search_flights' => 'products#go_search_flights', :as => "go_search_flights"
  post 'products/get_list_bus' => 'products#get_list_bus', :as => "get_list_bus"
  
  #post 'products/go_min_price_flights' => 'products#go_min_price_flights', :as => "go_min_price_flights"
  resources :products
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'products#index'

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
