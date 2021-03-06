Rails.application.routes.draw do

  root 'static_pages#home'
  get 'about', to: 'static_pages#about', as: 'about'
  get 'help', to: 'static_pages#help', as: 'help'
  get 'contact', to: 'static_pages#contact', as: 'contact'
  get 'new', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  patch 'update', to: 'users#update'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
