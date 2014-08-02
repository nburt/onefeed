Rails.application.routes.draw do
  root 'welcome#index'

  post '/users', to: 'registrations#create'
  get '/login', to: 'sessions#new', as: :new_session
  post '/sessions', to: 'sessions#create'
  get '/destroy', to: 'sessions#destroy'
  get '/passwords/reset', to: 'passwords#new', as: :forgot_password
  post '/passwords', to: 'passwords#send_email'
  get '/passwords/edit', to: 'passwords#edit', as: :edit_password
  put '/passwords', to: 'passwords#update'
  get '/auth/instagram/callback', to: 'instagram_registration#create'

  get '/account', to: 'accounts#show', as: :account

  get '/feed', to: 'feed#index', as: :feed
  namespace :api do
    get '/instagram-initial-feed', to: 'instagram_feed#initial_request'
  end
end
