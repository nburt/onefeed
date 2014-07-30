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

  get '/feed', to: 'feed#index', as: :feed
end
