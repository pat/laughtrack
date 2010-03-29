ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'home'
  map.four_oh_four '/404', :controller => 'home', :action => 'four_oh_four'
  map.five_hundred '/500', :controller => 'home', :action => 'five_hundred'
  map.about '/about',      :controller => 'home', :action => 'about'
  
  map.resources :shows, :member => { :tweets => :get }
  
  map.namespace :admin do |admin|
    admin.resources :shows, :member => {
      :feature      => :get,
      :unfeature    => :get,
      :clear_tweets => :get,
      :import_tweet => :post
    } do |shows|
      shows.resources :performances, :member => {
        :sold_out   => :get,
        :available  => :get,
        :destroy    => :get
      }
      shows.resources :keywords, :member => {
        :destroy => :get
      }
    end
    
    admin.resources :performers
    
    admin.resources :tweets, :member => {
      :positive => :get,
      :negative => :get,
      :ignore   => :get,
      :confirm  => :get
    }, :collection => {
      :unclassified => :get,
      :unconfirmed  => :get,
      :confirmed    => :get
    }
  end
  
  map.popular 'popular', :controller => 'shows', :action => 'index',
    :sort_by => 'sold_out_percent', :order => 'desc'
  map.quality 'quality', :controller => 'shows', :action => 'index',
    :sort_by => 'rating', :order => 'desc'
  
  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
end
