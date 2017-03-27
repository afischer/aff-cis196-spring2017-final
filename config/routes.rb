Rails.application.routes.draw do
  resources :parties
  resources :songs
  resources :users

  get '/' => 'welcome#index'
end
