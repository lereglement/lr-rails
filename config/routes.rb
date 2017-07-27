Rails.application.routes.draw do

  constraints(lambda { |req| req.host.match(/^bo\.lereglement\.(here|fm)$/) }) do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
  end

  constraints(lambda { |req| req.host.match(/^api\.lereglement\.(here|fm)$/) }) do
    namespace :api, :path => '/' do
      namespace :v1 do
        resources :connections, only: [:index]
      end
    end
  end

end
