Rails.application.routes.draw do

  constraints subdomain: 'www' do
    get ':any', to: redirect(subdomain: nil, path: '/%{any}'), any: /.*/
  end

  namespace :landing, :path => '/' do
    get :welcome, path: '/', to: 'welcome#index'
  end

end
