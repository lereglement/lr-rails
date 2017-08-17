class Api::V1::Playlists::NextSerializer < ActiveModel::Serializer

  attribute :artist do
    track = object.track
    track.artist
  end

  attribute :title do
    track = object.track
    track.title
  end

  attribute :type_of do
    track = object.track
    track.type_of
  end

  attribute :twitter do
    track = object.track
    artist = Artist.where(name: track.artist).first
    unless artist.twitter.blank?
      artist.twitter.split.map{ |account| "@#{account}"}.join(" ")
    end
  end

  attribute :cover_xsmall do
    track = object.track
    unless track.cover.blank?
      track.cover.path(:xsmall)
    else
      artist = Artist.where(name: track.artist).first
      unless artist.picture.blank?
        artist.picture.path(:xsmall)
      end
    end
  end

  attribute :cover_small do
    track = object.track
    unless track.cover.blank?
      track.cover.path(:small)
    else
      artist = Artist.where(name: track.artist).first
      unless artist.picture.blank?
        artist.picture.path(:small)
      end
    end
  end

  attribute :cover_medium do
    track = object.track
    unless track.cover.blank?
      track.cover.path(:medium)
    else
      artist = Artist.where(name: track.artist).first
      unless artist.picture.blank?
        artist.picture.path(:medium)
      end
    end
  end

  attribute :cover_large do
    track = object.track
    unless track.cover.blank?
      track.cover.path(:large)
    else
      artist = Artist.where(name: track.artist).first
      unless artist.picture.blank?
        artist.picture.path(:large)
      end
    end
  end

  attribute :file do
    track = object.track
    Track.find(object.track_id).transcoded_file if track.track_file_name
  end

end
