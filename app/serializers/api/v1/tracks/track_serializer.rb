class Api::V1::Tracks::TrackSerializer < ActiveModel::Serializer

  attributes :title,
    :artist

end
