class Data::V1::YoutubeVideosController < Data::V1::BaseController
  helper ApplicationHelper

  skip_before_action :authenticate_request!, only: [:get_playlist]

  def get_playlist
    playlist = get_youtube_videos(params)
    render json: { data: playlist }
  end


end
