Rails.application.routes.draw do
  root to: 'home#home'
  get 'home'  => 'home#home'
  get 'about' => 'home#about'
  get 'throwup' => 'home#throwup'
  get 'ping' => 'home#ping'

  # Thanks to https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  delete 'users/omniauth_accounts/:provider' => 'users/omniauth_accounts#destroy', as: 'users_omniauth_account'

  get "/users/search", to: "users#search", as: "search_users"
  resources :users, only: [:index, :show, :edit, :update]
  post "/users/:id/reset_password", to: "users#reset_password", as: "reset_password_user"

  get "/resources/search", to: "resources#search", as: "search_resources"
  resources :resources

  get "/projects/search", to: "projects#search", as: "search_projects"
  resources :projects, only: [:index, :show, :new, :create, :edit, :update]

  get "/posts/search", to: "posts#search", as: "search_posts"
  get "/posts/drafts", to: "posts#drafts", as: "drafts_posts"
  resources :posts, only: [:index, :show, :create, :edit, :update, :destroy]

  get "/search", to: "search#search", as: "search"

  resources :post_conversants, only: [:new, :create]

  resources :messages, only: [:new, :create]

  resources :notifications, only: [:index, :show]
  post "notifications/mark_all_read" => "notifications#mark_all_read", as: "mark_all_read_notifications"

  post   "like_flags/:target_type/:target_id" => "like_flags#create", as: "like_flag"
  delete "like_flags/:target_type/:target_id" => "like_flags#destroy"

  get    "stay_informed_flags/:target_type/:target_id" => "stay_informed_flags#index",
         as: "stay_informed_flags"
  post   "stay_informed_flags/:target_type/:target_id" => "stay_informed_flags#create",
         as: "stay_informed_flag"
  delete "stay_informed_flags/:target_type/:target_id" => "stay_informed_flags#destroy"

  get    "get_involved_flags/:target_type/:target_id" => "get_involved_flags#index",
         as: "get_involved_flags"
  post   "get_involved_flags/:target_type/:target_id" => "get_involved_flags#create",
         as: "get_involved_flag"
  delete "get_involved_flags/:target_type/:target_id" => "get_involved_flags#destroy"

  namespace :admin do
    get "elasticsearch_gui" => "elasticsearch_gui#page", as: "elasticsearch_gui"
    post "elasticsearch_gui/query" => "elasticsearch_gui#query"
  end
end
