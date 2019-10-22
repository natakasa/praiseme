Rails.application.routes.draw do
  get 'twitt/top'
  post 'twitt/create'
  root :to => 'twitt#top'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
