Rulez::Engine.routes.draw do

  root to: 'static#index'

  resources :contexts
  resources :rules do
    resources :alternatives
  end
  resources :variables

  get 'contexts/:id/variables', to: 'contexts#variables', as: 'context_variables'
  get 'doctor', to: 'static#doctor'
end
