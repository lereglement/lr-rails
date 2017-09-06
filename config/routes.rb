Rails.application.routes.draw do

  constraints(lambda { |req| req.host.match(/^www\.lereglement\.(here|sale)$/) }) do
    get "/" => redirect { |params| "http://lereglement.sale" }
  end

  constraints subdomain: 'www' do
    get ':any', to: redirect(subdomain: nil, path: '/%{any}'), any: /.*/
  end

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
        get :get_next_track, path: '/playlists/next', to: 'playlists#get_next'
        get :get_current_track, path: '/playlists/current', to: 'playlists#get_current'
        get :get_not_converted, path: '/tracks/not_converted', to: 'tracks#get_not_converted'
        get :get_not_downloaded, path: '/tracks/not_downloaded', to: 'tracks#get_not_downloaded'
        resources :tracks, only: [:create, :update]
      end
    end
  end

  constraints(lambda { |req| req.host.match(/^data(-staging)?\.lereglement\.(here|sale)$/) }) do
    namespace :data, :path => '/' do
      namespace :v1 do
        get :get_youtube_playlist, path: '/youtube_videos/playlist', to: 'youtube_videos#get_playlist'
        get :get_current_track, path: '/playlists/current', to: 'playlists#get_current'
        get :get_previous_tracks, path: '/playlists/previous', to: 'playlists#get_previous'
        resources :facebook, only: [:create, :show]
      end
    end
  end

  constraints(lambda { |req| req.host.match(/^(staging\.)?lereglement\.(here|sale)$/) }) do
    namespace :landing, :path => '/' do
      get :welcome, path: '/', to: 'welcome#index'
    end
  end

  namespace :landing, :path => '/' do
    get :welcome, path: '/', to: 'welcome#index'
  end

end
