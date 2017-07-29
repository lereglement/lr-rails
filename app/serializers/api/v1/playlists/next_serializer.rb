class Api::V1::Playlists::NextSerializer < ActiveModel::Serializer

  attribute :artist do
    object.track.artist
  end

  attribute :title do
    object.track.title
  end

  attribute :cover_xsmall do
    object.track.cover.path(:xsmall)
  end

  attribute :cover_small do
    object.track.cover.path(:small)
  end

  attribute :cover_medium do
    object.track.cover.path(:medium)
  end

  attribute :cover_large do
    object.track.cover.path(:large)
  end

  attribute :file do
    TrackLib.transcoded_file(Track.find(object.track_id))
  end

end
