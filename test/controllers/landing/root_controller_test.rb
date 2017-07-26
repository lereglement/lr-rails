require 'test_helper'

class Landing::RootControllerTest < ActionDispatch::IntegrationTest
  test "homepage" do
    get domain + "/"
    assert_response :success
  end
end
