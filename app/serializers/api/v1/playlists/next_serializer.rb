class Api::V1::Playlists::NextSerializer < ActiveModel::Serializer

  attribute :artist do
    track = object.track
    track.artist
  end

  attribute :title do
    track = object.track
    track.title
  end

  attribute :twitter do
    track = object.track
    artist = Artist.where(name: track.artist).first
    unless artist.twitter.blank?
      artist.twitter.split.map{ |account| "@#{account}"}.join(" ")
    end
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
    track = object.track
    TrackLib.transcoded_file(Track.find(object.track_id)) if track.track_file_name
  end

end
