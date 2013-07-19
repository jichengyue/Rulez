Rulez::Engine.routes.draw do
  root to: 'static#index'

  resources :contexts
  resources :rules
  resources :symbols

  get 'contexts/:id/symbols', to: 'contexts#symbols', as: 'context_symbols'
end
