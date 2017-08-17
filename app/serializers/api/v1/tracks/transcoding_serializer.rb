class Api::V1::Tracks::TranscodingSerializer < ActiveModel::Serializer

  attribute :source do
    object.track.path
  end

  attribute :target do
    object.transcoded_file
  end

  attribute :quality do
    Rails.application.secrets.output_quality
  end

  attribute :pong do
    "#{Rails.application.secrets.domain_api_url}/#{Rails.application.secrets.api_version}/tracks/#{object.ref}"
  end

end
