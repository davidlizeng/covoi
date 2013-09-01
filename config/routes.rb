Covoi::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  # default_url_options :host => "localhost:3000"
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  match 'iforgot/new' => 'iforgot#new'
  match 'iforgot/new_post' => 'iforgot#new_post'
  match 'iforgot/reset' => 'iforgot#reset'
  match 'iforgot/reset_post' => 'iforgot#reset_post'
  match 'users/myrides' => 'users#myrides'
  match 'admin/sort' => 'admins#sort'
  match 'users/fb_link' => 'users#fb_link'
  # This route can be invoked with purchase_url(:id => product.id)
  # match '/' => 'session#new', :as => :new_session
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resource :session, :only => [:new, :create, :destroy]
  resource :admin, :only => [:show, :create]
  resources :users, :only => [:new, :create, :show, :edit, :update]
  resources :trips, :only => [:create]
  resources :matches, :only => [:create]

  #For Facebook
  get '/channel.html' => proc {
    [
      200,
      {
        'Pragma' => 'public',
        'Cache-Control' => "max-age=#{1.year.to_i}",
        'Expires' => 1.year.from_now.to_s(:rfc822),
        'Content-Type' => 'text/html'
      },
      ['<script type="text/javascript" src="//connect.facebook.net/en_US/all.js"></script>']
    ]
  }

  #map.facebook :facebook, :controller => :user, :action => :facebook

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'sessions#new'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
