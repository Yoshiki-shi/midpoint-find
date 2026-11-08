Rails.application.routes.draw do
  root "static_pages#top"
  get "up" => "rails/health#show", as: :rails_health_check
  get '/signup', to: 'users#new'

  resources :users
end
