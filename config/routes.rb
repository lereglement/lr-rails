Rails.application.routes.draw do


  constraints(lambda { |req| req.host.match(/bobonn\.io/) }) do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    post :send, path: '/chat/message', to: 'chat#message'
  end

  constraints(lambda { |req| req.host.match(/^(api|api-dev)?\.getbonnie/) }) do
    namespace :api, :path => '/' do
      namespace :v3 do
        resources :connections, only: [:index]
      end
    end
  end

end
