Rails.application.routes.draw do
  root "articles#index"
  #get "/articles"
  #get "/articles", to: "articles#index"
  #get "/articles/:id", to: "articles#show"
  #match "/articles/:id", to: "articles#new", via: [:get, :post]
  #match "/articles/:id", to: "articles#create", via: [:get, :post]
  resources :articles
end