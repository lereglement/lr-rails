class Data::V1::PlaylistsController < Data::V1::BaseController

  skip_before_action :authenticate_request!, only: [:get_current, :get_previous]

  def get_current
    current_track = Track.get_current

    render json: current_track,
      root: 'data',
      serializer: Data::V1::Tracks::TrackSerializer
  end

  def get_previous
    limit = params.fetch(:limit, 10)

    render json: Track.get_previous(limit),
      root: 'data',
      each_serializer: Data::V1::Tracks::TrackSerializer
  end


end
