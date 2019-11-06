Rails.application.routes.draw do
  get 'twitt/top'
  post 'twitt/create'
  root :to => 'twitt#top'
  post 'twitt/ajax_create'
  post '/auth/:provider/callback', to: 'twitt#create'
  get '/auth/:provider/callback', to: 'twitt#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
