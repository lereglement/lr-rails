class Api::V3::BaseController < ActionController::API

  before_action :authenticate_request!

  def meta_attributes(collection, extra_meta = {})
    if collection.present?
      {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page, # use collection.previous_page when using will_paginate
        total_pages: collection.total_pages,
        total_count: collection.total_count
      }.merge(extra_meta)
    else
      extra_meta
    end
  end

  protected

    def api_error(status: 500, errors: [])
      puts errors.full_messages if errors.respond_to?(:full_messages)
      render json: Api::V3::ErrorSerializer.new(status, errors).as_json, status: status
    end

    def current_user
      @user_id.nil? ? @current_user : User.find_by(id: @user_id)
    end

    # Validates the token and user and sets the @current_user scope
    def authenticate_request!
      @user_id = request.headers['user']
      unless @user_id && (Rails.env.development? || Rails.env.test?)
        if !payload || !JwtTokenLib.valid_payload(payload.first)
          return invalid_authentication
        end

        load_current_user!
        invalid_authentication unless @current_user
      end
    end

    # Returns 401 response. To handle malformed / invalid requests.
    def invalid_authentication
      render json: {error: 'Invalid Request'}, status: :unauthorized
    end

    def pass_scope(data = {})
      {
        current_user: current_user
      }.merge(data)
    end

  private

    # Deconstructs the Authorization header and decodes the JWT token.
    def payload
      auth_header = request.headers['Authorization']
      token = auth_header.split(' ').last
      JwtTokenLib.decode(token)
    rescue
      nil
    end

    # Sets the @current_user with the user_id from payload
    def load_current_user!
      @current_user = User.find_by(ref: payload[0]['user_ref'])
    end


end
