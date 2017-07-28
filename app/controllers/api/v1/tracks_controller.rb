class Api::V1::TracksController < Api::V1::BaseController

  def get_not_converted
    tracks = Track.where(is_converted: false)

    render json: tracks,
      root: 'data',
      each_serializer: Api::V1::Tracks::TranscodingSerializer
  end

  def set_converted
    id = params[:id]

    Track.find(id).update(is_converted: true)

    render json: true
  end

  def update
    ref = params[:id]

    track = Track.find_by(ref: ref)
    api_error(status: 500, errors: "Missing track") and return false if track.nil?

    track_params = params[:track].permit(:is_converted, :duration, :bitrate)

    Track.find(track.id).update(track_params)

    render json: true
  end


end
