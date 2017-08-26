class Data::V1::PlaylistsController < Data::V1::BaseController

  skip_before_action :authenticate_request!, only: [:get_current]

  def get_current
    current_track = Track.get_current

    render json: current_track,
      root: 'data',
      serializer: Data::V1::Tracks::TrackSerializer
  end


end
