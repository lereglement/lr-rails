Rails.application.routes.draw do

  constraints(lambda { |req| req.host.match(/^obs(-staging)?\.lereglement\.(here|xyz)$/) }) do
    namespace :obs, :path => '/' do
      get :track, path: '/tracks/current', to: 'tracks#current'
    end
  end

  constraints(lambda { |req| req.host.match(/^bo(-staging)?\.lereglement\.(here|xyz)$/) }) do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
  end

  constraints(lambda { |req| req.host.match(/^api(-staging)?\.lereglement\.(here|xyz)$/) }) do
    namespace :api, :path => '/' do
      namespace :v1 do
        get :get_youtube_playlist, path: '/youtube_videos/playlist', to: 'youtube_videos#get_playlist'
        get :get_next_track, path: '/playlists/next', to: 'playlists#get_next'
        get :get_current_track, path: '/playlists/current', to: 'playlists#get_current'
        get :get_not_converted, path: '/tracks/not_converted', to: 'tracks#get_not_converted'
        get :get_not_downloaded, path: '/tracks/not_downloaded', to: 'tracks#get_not_downloaded'
        resources :tracks, only: [:create, :update]
      end
    end
  end

  constraints(lambda { |req| req.host.match(/^(staging\.)?lereglement\.(here|sale)$/) }) do
    namespace :landing, :path => '/' do
      get :root, path: '/', to: 'root#index'
    end
  end

  get :root, path: '/', to: 'root#index'

end
