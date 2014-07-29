Rails.application.routes.draw do
  root 'welcome#index'
  post '/users', to: 'registrations#create'
  get '/feed', to: 'feed#index', as: :feed
  post '/sessions', to: 'sessions#create'
  get '/destroy', to: 'sessions#destroy'
end
