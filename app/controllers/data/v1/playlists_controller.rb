class Data::V1::PlaylistsController < Data::V1::BaseController

  skip_before_action :authenticate_request!, only: [:get_current, :get_previous]

  def get_current
    current_track = Track.get_current(15)
    Rails.logger.debug "======================================================================================"
    Rails.logger.debug Time.now
    Rails.logger.debug "======================================================================================"
    if Time.now > '2017-09-14 21:00' && Time.now < '2017-09-14 23:59'
      Rails.logger.debug "TRANCHE A"
    end
    if Time.now > '2017-09-14 18:00' && Time.now < '2017-09-14 19:00'
      Rails.logger.debug "TRANCHE B"
    end

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
