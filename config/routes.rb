Laughtrack::Application.routes.draw do
  devise_for :admins, :skip => :registration
  devise_for :users

  root :to => 'home#index'
  
  match '/404'   => 'home#four_oh_four', :as => :four_oh_four
  match '/500'   => 'home#five_hundred', :as => :five_hundred
  match '/about' => 'home#about',        :as => :about
  
  resources :shows do
    member do
      get :tweets
    end
  end
  
  namespace :admin do
    resources :shows do
      member do
        get  :feature, :unfeature, :clear_tweets
        post :import_tweets
      end
      
      resources :performances do
        member do
          get :sold_out, :available, :delete
        end
      end
      
      resources :keywords do
        member { get :delete }
      end
    end
    
    resources :performers
    
    resources :tweets do
      member do
        get :positive, :negative, :ignore, :confirm
      end
      collection do
        get :unclassified, :unconfirmed, :confirmed
      end
    end
    
    resources :admins, :only => :index do
      collection { post :invite }
    end
  end
  
  match '/popular' => 'shows#index', :as => :popular,
    :defaults => {:sort_by => 'sold_out_percent', :order => 'desc'}
  match '/quality' => 'shows#index', :as => :quality,
    :defaults => {:sort_by => 'rating', :order => 'desc'}
  
  match '/performances/:year/:month/:date' => 'performances#index',
    :as => :performances_by_date
  match '/performances'                    => 'performances#index'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
