class Api::V1::Playlists::NextSerializer < ActiveModel::Serializer

  attribute :artist do
    object.track.artist
  end

  attribute :title do
    object.track.title
  end

  attribute :cover do
    object.track.cover.url(:large)
  end

  attribute :file do
    TrackLib.transcoded_file(Track.find(object.track_id))
  end

end
