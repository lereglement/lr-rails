require 'test_helper'

class MediaControllerTest < ActionDispatch::IntegrationTest

  test "post media" do
    portrait = {
      medium: {
        item: "https://en.wikipedia.org/static/images/project-logos/enwiki.png",
        type_of: :portrait
      }
    }
    picture = {
      medium: {
        item: "https://en.wikipedia.org/static/images/project-logos/enwiki.png",
        type_of: :picture
      }
    }

    post api_domain + "/v3/media", params: portrait, as: :json, headers: { user: 5 }
    post api_domain + "/v3/media", params: portrait, as: :json, headers: { user: 5 }
    post api_domain + "/v3/media", params: picture, as: :json, headers: { user: 5 }
    post api_domain + "/v3/media", params: picture, as: :json, headers: { user: 5 }
    post api_domain + "/v3/media", params: picture, as: :json, headers: { user: 5 }

    get api_domain + "/v3/me", headers: { user: 5 }
    assert_response :success

    response = JSON.parse(@response.body)["data"]
    assert_equal 3, response["picture_count"]
    assert_equal 2, response["portrait_count"]
  end

  test "post missing media" do
    portrait = {
      medium: {
        url: "https://en.wikipedia.org/static/images/project-logos/enwiki.png",
        type_of: :portrait
      }
    }

    post api_domain + "/v3/media", params: portrait, as: :json, headers: { user: 5 }

    get api_domain + "/v3/me", headers: { user: 5 }
    assert_response :success

    response = JSON.parse(@response.body)["data"]
    assert_equal 0, response["portrait_count"]
  end

end
