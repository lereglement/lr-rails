require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module LeReglement
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Paris'

    config.read_encrypted_secrets = true

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options, :put, :delete]
      end
    end

    Raven.configure do |config|
      config.dsn = 'https://819acef0a5e24b34920b79581b65c80f:21bfa547f8524eaaae7cf849098d1c14@sentry.io/936325'
    end

  end
end
