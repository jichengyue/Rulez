Rails.application.routes.draw do

  resources :users


  resources :restaurants


  root to: "static#index"

  mount Rulez::Engine, at: "/rulez"
end
