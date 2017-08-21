class Data::V1::PlaylistsController < Data::V1::BaseController

  skip_before_action :authenticate_request!, only: [:get_current]

  def get_current
    current_track = Playlist.joins("INNER JOIN tracks ON tracks.id = playlists.track_id AND tracks.type_of = 'track'").where(is_aired: true).order(id: :desc).first.track

    render json: current_track,
      root: 'data',
      serializer: Data::V1::Tracks::TrackSerializer
  end


end
