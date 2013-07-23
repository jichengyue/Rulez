Rails.application.routes.draw do

  root to: "static#index"

  mount Rulez::Engine => "/rulez", as: 'rulez'
end
