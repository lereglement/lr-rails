require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  test "access_without_token" do
    get api_domain + "/v3/me"
    assert_response :unauthorized
  end

  test "me" do
    get api_domain + "/v3/me", headers: { user: 1 }
    assert_response :success
  end

  test "me update" do
    attributes = {
      user: {
        first_name: "Paul",
        age: 80,
        gender: "male",
        gender_target: "bisexual"
      }
    }
    put api_domain + "/v3/me", params: attributes, as: :json, headers: { user: 1 }
    assert_response :success

    user = User.find(1)
    assert_equal user[:age], 80
    assert_equal user[:first_name], "Paul"
  end

  test "get user" do
    get api_domain + "/v3/users/84d73caf340ead441d5dd1f635a339c8", headers: { user: 2 }
    assert_response :success

    response = JSON.parse(@response.body)["data"]

    first_name = response["first_name"]
    assert_equal "Olivier", first_name

    portrait_ref = response["portraits"][0]["ref"]
    assert_equal "c9d0a766b05d4d3a0e1f3ccb47b1214591a78344", portrait_ref
  end

  test "activate" do
    post api_domain + "/v3/activate", headers: { user: 5 }
    assert_response :unauthorized
  end

  test "activate successful" do
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
    post api_domain + "/v3/media", params: picture, as: :json, headers: { user: 5 }
    post api_domain + "/v3/media", params: picture, as: :json, headers: { user: 5 }
    post api_domain + "/v3/media", params: picture, as: :json, headers: { user: 5 }

    post api_domain + "/v3/activate", headers: { user: 5 }
    assert_response :success

    response = JSON.parse(@response.body)["data"]
    assert_equal true, response["is_onboarded"]
  end
end
