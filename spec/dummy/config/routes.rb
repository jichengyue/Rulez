Rails.application.routes.draw do

  resources :restaurants


  root to: "static#index"

  mount Rulez::Engine => "/rulez", as: 'rulez'
end
