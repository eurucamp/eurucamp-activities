Activities::Application.routes.draw do
  devise_for :users
  resources :activities

  root to: 'activities#index'
end
