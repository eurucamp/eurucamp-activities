Activities::Application.routes.draw do
  resource :activities

  root to: 'activities#index'
end
