Rails.application.routes.draw do

  constraints subdomain: 'www' do
    get ':any', to: redirect(subdomain: nil, path: '/%{any}'), any: /.*/
  end

  constraints(lambda { |req| req.host.match(/^data(-staging)?\.lereglement\.(here|sale)$/) }) do
    namespace :data, :path => '/' do
      namespace :v1 do
        get :get_youtube_playlist, path: '/youtube_videos/playlist', to: 'youtube_videos#get_playlist'
        get :get_current_track, path: '/playlists/current', to: 'playlists#get_current'
        get :get_previous_tracks, path: '/playlists/previous', to: 'playlists#get_previous'
        resources :facebook, only: [:create, :show]
        resources :settings, only: [:index]
      end
    end
  end

  namespace :landing, :path => '/' do
    get :welcome, path: '/', to: 'welcome#index'
  end

end
