class Api::V1::TracksController < Api::V1::BaseController

  def get_not_converted
    tracks = Track.where(is_converted: false).where.not(track_file_name: false)

    render json: tracks,
      root: 'data',
      each_serializer: Api::V1::Tracks::TranscodingSerializer
  end

  def get_not_downloaded
    tracks = Track.where.not(external_source: nil).where.not(external_source: "").where(track_file_name: nil).where.not(state: [:rejected, :to_review]).order(:id).limit(200)

    render json: tracks,
      root: 'data',
      each_serializer: Api::V1::Tracks::NotDownloadedSerializer
  end

  def create
    track_params = params[:track].permit(:title, :artist, :track, :external_source, :title_external_source, :ref_external_source, :origin_external_source, :state)
    Track.create({ state: :wip, type_of: :track }.merge(track_params))

    render json: true
  end

  def update
    ref = params[:id]

    track = Track.find_by(ref: ref)
    api_error(status: 500, errors: "Missing track") and return false if track.nil?

    track_params = params[:track].permit(:is_converted, :duration, :bitrate, :duration_converted, :cover, :origin_external_source, :ref_external_source, :title_external_source, :track, :state, :error_logs)

    Track.find(track.id).update(track_params)

    render json: true
  end


end
