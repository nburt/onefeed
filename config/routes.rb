Rails.application.routes.draw do
  root 'welcome#index'

  post '/users', to: 'registrations#create'
  get '/login', to: 'session#new', as: :new_session
  post '/sessions', to: 'session#create'
  get '/destroy', to: 'session#destroy'
  get '/passwords/reset', to: 'passwords#new', as: :forgot_password
  post '/passwords', to: 'passwords#send_email'
  get '/passwords/edit', to: 'passwords#edit', as: :edit_password
  put '/passwords', to: 'passwords#update'
  get '/auth/instagram/callback', to: 'instagram_registration#create'
  get '/auth/twitter/callback', to: 'twitter_registration#create'
  get '/auth/facebook/callback', to: 'facebook_registration#create'

  get '/account', to: 'accounts#show', as: :account

  get '/feed', to: 'feed#index', as: :feed
  namespace :api do
    get '/feed', to: 'feed#index'
    get '/profile_picture', to: 'profile_pictures#show'
  end
end
