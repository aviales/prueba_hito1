Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    resources :tweets, :path => "news"
  end

  get '/api/:fecha1/:fecha2', to: 'api/tweets#between_dates'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :tweets do
    post 'like', to: 'tweets#like'
    post 'retweet', to: 'tweets#retweet'
  end

  root 'tweets#index'
  get '/tweets/hashtag/:name', to:'tweets#hashtags'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
