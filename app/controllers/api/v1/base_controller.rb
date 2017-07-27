class Api::V1::BaseController < ActionController::API

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
      render json: Api::V1::ErrorSerializer.new(status, errors).as_json, status: status
    end

end
