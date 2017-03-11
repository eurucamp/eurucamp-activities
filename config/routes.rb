Rails.application.routes.draw do
  resources  :authentications, only: [:create, :destroy]
  get '/auth/:provider/callback' => 'authentications#create'

  devise_for :users, controllers: {
    registrations: 'registrations',
    sessions: 'sessions',
    passwords: 'passwords'
  }

  resources :activities do
    resource :participation, only: [:create, :destroy]
  end
  root to: 'activities#index'
end
