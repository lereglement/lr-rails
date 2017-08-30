class Data::V1::YoutubeVideosController < Data::V1::BaseController

  skip_before_action :authenticate_request!, only: [:get_playlist]

  def get_playlist
    q = params.fetch(:q, nil)
    results = params.fetch(:results, 50)
    remove_live = params.fetch(:remove_live, 0)

    url = "https://www.googleapis.com/youtube/v3/search?key=#{Rails.application.secrets.youtube_api_key}&channelId=#{Rails.application.secrets.youtube_channel_id}&part=id,snippet&type=video&order=date&maxResults=#{results}&q=#{q}"
    http = Curl.get(url)
    api_error(status: 500, errors: "Youtube API not responding") and return false if !http.body_str

    body = JSON.parse(http.body_str)
    api_error(status: 500, errors: "Youtube API items missing") and return false if !body["items"]

    ids = []
    body["items"].each do |item|
      if item["snippet"]["liveBroadcastContent"] != "live" || remove_live.to_i == 0
        ids.push(item["id"]["videoId"])
      end
    end

    url = "https://www.googleapis.com/youtube/v3/videos?key=#{Rails.application.secrets.youtube_api_key}&channelId=#{Rails.application.secrets.youtube_channel_id}&part=snippet,statistics&id=#{ids.join(',')}"
    http = Curl.get(url)
    api_error(status: 500, errors: "Youtube API not responding") and return false if !http.body_str

    body = JSON.parse(http.body_str)
    api_error(status: 500, errors: "Youtube API items missing") and return false if !body["items"]

    playlist = []
    body["items"].each do |item|
      playlist.push({
        id: item["id"],
        url: "https://www.youtube.com/watch?v=#{item["id"]}",
        title: item["snippet"]["title"],
        statistics: {
          view_count: item["statistics"]["viewCount"],
          like_count: item["statistics"]["likeCount"],
          dislike_count: item["statistics"]["dislikeCount"],
          comment_count: item["statistics"]["commentCount"],
        },
        thumbnail: {
          url: item["snippet"]["thumbnails"]["high"]["url"],
          width: item["snippet"]["thumbnails"]["high"]["width"],
          height: item["snippet"]["thumbnails"]["high"]["height"],
        }
      })
    end

    render json: { data: playlist }
  end


end
