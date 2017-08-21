require 'curb'

class Data::V1::FacebookController < Data::V1::BaseController

  skip_before_action :authenticate_request!, only: [:create, :show]

  def show
    api_error(status: 500, errors: "Wrong request") and return false if params[:id].nil?
    api_error(status: 500, errors: "Wrong header") and return false unless check_facebook(params[:id])

    facebook = FacebookUser.where(facebook_ref: params[:id]).first
    user = facebook ? User.where(facebook_user_id: facebook[:id]).first : nil

    if user.nil?
      data = nil
    else
      data = {
        token: get_token(user)
      }
    end
    render json: { data: data }
  end

  def create
    api_error(status: 500, errors: "Wrong request") and return false if params[:facebook].nil?

    facebook_params = params[:facebook].permit(:id, :first_name, :last_name, :email, :gender, :birthday)

    api_error(status: 500, errors: "Wrong header") and return false unless check_facebook(facebook_params[:id])

    facebook_params["facebook_ref"] = facebook_params.delete("id")

    facebook = FacebookUser.where(facebook_ref: facebook_params[:facebook_ref]).first_or_create(facebook_params)
    api_error(status: 500, errors: "FB params missing") and return false unless facebook.valid?

    user = User.where(facebook_user_id: facebook[:id]).first

    if user.nil?
      user_params = {
        facebook_user_id: facebook[:id],
        first_name: facebook[:first_name],
        last_name: facebook[:last_name],
        email: facebook[:email],
        gender: facebook[:gender],
        birthday: facebook[:birthday]
      }
      user = User.create(user_params)
      api_error(status: 500, errors: "User params missing") and return false unless user.valid?
    end

    render json: {
      data: {
        token: get_token(user)
      }
    }
  end

  private
    def get_token(user)
      JwtTokenLib.encode({ user_ref: user[:ref] })
    end

    def check_facebook(id)
      @skip_token = request.headers['skip-fb']
      if @skip_token && (Rails.env.development? || Rails.env.test?)
        return true
      end
      if request.headers["HTTP_AUTHORIZATION"].nil? || request.headers["HTTP_AUTHORIZATION"][0,7] != "Bearer "
        false
      else
        bearer = request.headers["HTTP_AUTHORIZATION"]

        c = Curl::Easy.new
        url = "https://graph.facebook.com/v2.9/me"
        headers={}
        headers['Authorization'] = bearer
        c.url = url
        c.headers = headers
        c.perform

        facebook_result = JSON.parse c.body_str
        facebook_result_id = facebook_result.to_h["id"]

        facebook_result_id.to_s == id.to_s
      end
    end

end
