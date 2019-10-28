Rails.application.routes.draw do
  get 'twitt/top'
  post 'twitt/create'
  root :to => 'twitt#top'
  post 'twitt/ajax_create'
  #https://qiita.com/fezrestia/items/e669107a4a6e66618738
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
