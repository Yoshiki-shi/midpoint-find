Rails.application.routes.draw do
  root "static_pages#top"
  get "up" => "rails/health#show", as: :rails_health_check
  get "/signup", to: "users#new"
  get "terms", to: "static_pages#terms"
  get "privacy", to: "static_pages#privacy"

  resources :users, only: %i[new create]
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resource :profile, only: %i[show edit update]
  resource :password, only: %i[edit update]

  resources :members, only: %i[index create edit update destroy] do
    patch :update_default_station, on: :collection
  end

  resources :meeting_events, only: %i[new create show]
  get "share/:token", to: "shares#show", as: :share_event
end