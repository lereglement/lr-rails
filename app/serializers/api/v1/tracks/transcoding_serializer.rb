class Api::V1::Tracks::TranscodingSerializer < ActiveModel::Serializer

  attribute :source do
    object.track.path
  end

  attribute :target do
    filename = object.track.path.scan(/original\/(\w+)/)[0][0]
    "/transcoded/#{filename.scan(/.{4}/).join("/")}/#{Rails.application.secrets.output_quality}.#{Rails.application.secrets.output_format}"
  end

  attribute :quality do
    Rails.application.secrets.output_quality
  end

  attribute :pong do
    "URL"
  end



end
