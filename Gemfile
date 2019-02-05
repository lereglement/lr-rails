source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem "autoprefixer-rails"
gem "mini_magick", '~> 4.7.0'
gem "paperclip", "~> 5.1.0"
gem 'active_model_serializers', '~> 0.10.6'
gem 'activeadmin', '~> 1.0.0'
gem 'aws-sdk', '~> 2.3.0'
gem 'cancancan', '~> 2.0'
gem 'coffee-rails', '~> 4.2.1'
gem 'curb', '0.9.7'
gem 'devise', '~> 4.3.0'
gem 'dotiw', '~> 3.1.1'
gem 'httparty', '~> 0.15.6'
gem 'inherited_resources', '~> 1.7'
gem 'jbuilder', '~> 2.5'
gem 'jwt', '~> 1.5.6'
gem 'kaminari', '~> 1.0.1'
gem 'meta-tags', '~> 2.4.0'
gem 'mysql2', '0.4.10'
gem 'nilify_blanks', '~> 1.2.0'
gem 'puma', '~> 3.0'
gem 'r7insight'
gem 'rack-cors', "~> 0.4.1"
gem 'rails', '~> 5.1.0'
gem 'rails-assets-jquery.inview', source: 'https://rails-assets.org'
gem 'rails-assets-jqueryui', source: 'https://rails-assets.org'
gem 'rails3-jquery-autocomplete', '~> 1.0.11'
gem 'sass-rails', '~> 5.0'
gem "sentry-raven"
gem 'slim', '~> 3.0.7'
gem 'therubyracer', git: 'https://github.com/cowboyd/therubyracer.git'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem "better_errors"
  gem "binding_of_caller"
  gem "rspec-rails"

end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
