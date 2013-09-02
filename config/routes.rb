Rulez::Engine.routes.draw do

  root to: 'static#index'

  resources :contexts
  resources :rules do
    resources :alternatives, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :variables

  get 'contexts/:id/variables', to: 'contexts#variables', as: 'context_variables'
  post 'rules/:id/sort_alternatives', to: 'rules#sort_alternatives'
  get 'flush_log', to: 'static#flush_log'
  get 'doctor', to: 'static#doctor'
  get 'displaylog', to: 'static#displaylog'
  get 'clearlogfile', to: 'static#clearlogfile'
end
