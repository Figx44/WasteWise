Rails.application.routes.draw do

  root to: "pages#dashboard"
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Google Vision Route
  # post '/waste_items/analyze', to: 'waste_items#analyze'
  get 'vision_analyze', to: 'visions#vision_analyze', as: "visonresult"
  post 'vision/analyze', to: 'visions#analyze'

  get "home", to: "pages#home"
  # Dashboard
  get "about", to: "pages#about"
  # User route with
  get "/search", to: "waste_items#search"
  get "/team", to: "pages#team"
  resources :waste_items, only: %i[index show new]

  resources :user, only: %i[] do
    resources :waste_items, only: %i[new create index new]
  end

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
