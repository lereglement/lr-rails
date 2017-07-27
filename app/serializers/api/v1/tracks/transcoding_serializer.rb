class Api::V1::Tracks::TranscodingSerializer < ActiveModel::Serializer

  attribute :source do
    object.track.url
  end

  attribute :target do
    filename = object.track.path.scan(/original\/(\w+)/)[0][0]
    "/transcoded/#{filename.scan(/.{4}/).join("/")}/128abr.mp3"
  end

  attribute :quality do
    "128abr"
  end

  attribute :pong do
    "URL"
  end



end
