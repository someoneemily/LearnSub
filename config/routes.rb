Rails.application.routes.draw do
  resources :interests
  
  root to: 'interests#index'
end
