Rulez::Engine.routes.draw do
  root to: 'static#index'

  resources :contexts
end
