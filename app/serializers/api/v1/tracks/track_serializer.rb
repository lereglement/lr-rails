class Api::V1::Tracks::TrackSerializer < ActiveModel::Serializer

  attributes :title,
    :artist,
    :year

  attribute :target do
    TrackLib.transcoded_file(object)
  end

end
