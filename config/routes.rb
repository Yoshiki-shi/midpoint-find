Rails.application.routes.draw do
  root "static_pages#top"
  get "up" => "rails/health#show", as: :rails_health_check
  get '/signup', to: 'users#new'

  resources :users

  # ログイン画面の表示
  get 'login', to: 'sessions#new'
  # ログイン処理（入力値の検証、セッションへの保存）
  post 'login', to: 'sessions#create'
  # ログアウト処理（セッションからユーザーIDを削除）
  delete 'logout', to: 'sessions#destroy'
end