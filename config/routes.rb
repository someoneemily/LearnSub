Rails.application.routes.draw do
  resources :searches
  resources :interests

  root to: 'interests#index'
end
