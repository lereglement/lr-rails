ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def api_domain
    Rails.application.secrets.domain_api_url
  end

  def domain
    Rails.application.secrets.domain_url
  end

  # Add more helper methods to be used by all tests here...
end
