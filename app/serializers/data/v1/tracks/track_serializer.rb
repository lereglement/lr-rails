class Data::V1::Tracks::TrackSerializer < ActiveModel::Serializer

  attributes :title,
    :artist,
    :external_source,
    :origin_external_source

  attribute :is_new do
    object.aired_count <= Rails.application.secrets.track_new_limit ? true : false
  end

  attribute :is_mif do
    artist = Artist.where(name: object.artist).first
    if artist.type_of == "mif"
      true
    else
      false
    end
  end

  attribute :cover_xsmall do
    artist = Artist.where(name: object.artist).first
    if artist.picture.blank?
      Rails.application.secrets.missing_cover
    else
      artist.picture.url(:xsmall)
    end
  end

  attribute :cover_small do
    artist = Artist.where(name: object.artist).first
    if artist.picture.blank?
      Rails.application.secrets.missing_cover
    else
      artist.picture.url(:small)
    end
  end

  attribute :cover_medium do
    artist = Artist.where(name: object.artist).first
    if artist.picture.blank?
      Rails.application.secrets.missing_cover
    else
      artist.picture.url(:medium)
    end
  end

  attribute :cover_large do
    artist = Artist.where(name: object.artist).first
    if artist.picture.blank?
      Rails.application.secrets.missing_cover
    else
      artist.picture.url(:large)
    end
  end

end
