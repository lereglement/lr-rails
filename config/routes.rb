Rails.application.routes.draw do

  constraints(lambda { |req| req.host.match(/^bo\.lereglement\.(here|xyz)$/) }) do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
  end

  constraints(lambda { |req| req.host.match(/^api?\.lereglement\.(here|xyz)$/) }) do
    namespace :api, :path => '/' do
      namespace :v1 do
        get :get_next_track, path: '/playlists/next', to: 'playlists#get_next'
        get :get_not_converted, path: '/tracks/not_converted', to: 'tracks#get_not_converted'
        resources :tracks, only: [:update]
      end
    end
  end

  constraints(lambda { |req| req.host.match(/^lereglement\.(here|sale)$/) }) do
    namespace :landing, :path => '/' do
      get :root, path: '/', to: 'root#index'
    end
  end

end
