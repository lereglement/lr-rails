class Api::V1::TracksController < Api::V1::BaseController

  def get_not_converted
    tracks = Track.where(is_converted: false)

    render json: tracks,
      root: 'data',
      each_serializer: Api::V1::Tracks::TranscodingSerializer
  end


end
