Activities::Application.routes.draw do
  resources  :authentications, only: [:create, :destroy]
  get '/auth/:provider/callback' => 'authentications#create'

  devise_for :users, controllers: {
    registrations: 'registrations',
    sessions: 'sessions',
    passwords: 'passwords'
  }

  resources :activities
  root to: 'activities#index'
end
