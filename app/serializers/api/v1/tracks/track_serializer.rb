class Api::V1::Tracks::TrackSerializer < ActiveModel::Serializer

  attributes :title,
    :artist

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

end
