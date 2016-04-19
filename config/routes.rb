Rails.application.routes.draw do
  get 'products/goibibo' => 'products#goibibo', :as => "goibibo"
  get 'products/google_api' => 'products#google_api', :as => "google_api"
  get 'products/semantic3' => 'products#semantic3', :as => "semantic3"
  post 'products/list_products' => 'products#list_products', :as => "list_product"
  post 'products/list_flights' => 'products#list_flights', :as => "list_flights"
  post 'products/list_countries' => 'products#list_countries', :as => "list_countries"
  post 'products/get_hotels' => 'products#get_hotels', :as => "get_hotels"
  post 'products/get_min_price_flights' => 'products#get_min_price_flights', :as => "get_min_price_flights"
  post 'products/go_search_flights' => 'products#go_search_flights', :as => "go_search_flights"
  post 'products/get_list_bus' => 'products#get_list_bus', :as => "get_list_bus"
  post 'products/get_hotel_list' => 'products#get_hotel_list', :as => "get_hotel_list"
  get 'products/railway' => 'products#railway', :as => "railway"
  post 'products/get_live_status' => 'products#get_live_status', :as => "get_live_status"
  post 'products/get_pnr_status' => 'products#get_pnr_status', :as => "get_pnr_status"
  post 'products/get_train_route' => 'products#get_train_route', :as => "get_train_route"
  post 'products/get_seat_avail' => 'products#get_seat_avail', :as => "get_seat_avail"
  post 'products/get_train_between' => 'products#get_train_between', :as => "get_train_between"
  post 'products/get_train_search' => 'products#get_train_search', :as => "get_train_search"
  post 'products/get_train_fare' => 'products#get_train_fare', :as => "get_train_fare"
  post 'products/get_train_arrival' => 'products#get_train_arrival', :as => "get_train_arrival"
  post 'products/get_cancel_train' => 'products#get_cancel_train', :as => "get_cancel_train"
  post 'products/get_search_station_code' => 'products#get_search_station_code', :as => "get_search_station_code"
  post 'products/get_search_station_name' => 'products#get_search_station_name', :as => "get_search_station_name"
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
