Rails.application.routes.draw do

  get 'account_activations/edit'

  get 'sessions/new'

  root 'static_pages#home'
  get 'about', to: 'static_pages#about', as: 'about'
  get 'help', to: 'static_pages#help', as: 'help'
  get 'contact', to: 'static_pages#contact', as: 'contact'
  get 'new', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  patch 'update', to: 'users#update'
  resources :users
  resources :account_activations, only: [:edit]


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
