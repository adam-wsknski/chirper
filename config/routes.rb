Rails.application.routes.draw do
  root 'static_pages#home'
  get 'about', to: 'static_pages#about', as: 'about'
  get 'help', to: 'static_pages#help', as: 'help'
  get 'contact', to: 'static_pages#contact', as: 'contact'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
