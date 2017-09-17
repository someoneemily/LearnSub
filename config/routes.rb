Rails.application.routes.draw do
  devise_for :users
  resources :searches
  resources :interests

  root to: 'interests#index'
end
