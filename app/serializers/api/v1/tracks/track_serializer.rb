class Api::V1::Tracks::TrackSerializer < ActiveModel::Serializer

  attributes :title,
    :artist

    attribute :cover_xsmall do
      track = object
      unless track.cover.blank?
        track.cover.url(:xsmall)
      else
        artist = Artist.where(name: track.artist).first
        unless artist.picture.blank?
          artist.picture.url(:xsmall)
        end
      end
    end

    attribute :cover_small do
      track = object
      unless track.cover.blank?
        track.cover.url(:small)
      else
        artist = Artist.where(name: track.artist).first
        unless artist.picture.blank?
          artist.picture.url(:small)
        end
      end
    end

    attribute :cover_medium do
      track = object
      unless track.cover.blank?
        track.cover.url(:medium)
      else
        artist = Artist.where(name: track.artist).first
        unless artist.picture.blank?
          artist.picture.url(:medium)
        end
      end
    end

    attribute :cover_large do
      track = object
      unless track.cover.blank?
        track.cover.url(:large)
      else
        artist = Artist.where(name: track.artist).first
        unless artist.picture.blank?
          artist.picture.url(:large)
        end
      end
    end

end
