Laughtrack::Application.routes.draw do
  devise_for :users, :controllers => {:omniauth_callbacks => 'twitter'} do
    get 'sign_in',  :to => 'devise/sessions#new',
      :as => :new_user_session
    get 'sign_out', :to => 'devise/sessions#destroy',
      :as => :destroy_user_session
  end

  namespace :manage do
    match '/' => 'home#index', :as => :dashboard
    resources :shows
    resources :tweets do
      collection do
        get :unclassified, :detached
        put :bulk_update
      end
      member do
        put :attach
      end
    end
  end

  root :to => 'home#index'
end
