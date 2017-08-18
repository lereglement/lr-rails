class Api::V1::YoutubeVideosController < Api::V1::BaseController

  def get_playlist

    url = "https://www.googleapis.com/youtube/v3/search?key=#{Rails.application.secrets.youtube_api_key}&channelId=#{Rails.application.secrets.youtube_channel_id}&part=snippet,id&order=date&maxResults=20"
    http = Curl.get(url)
    api_error(status: 500, errors: "Youtube API not responding") and return false if !http.body_str

    parsed = JSON.parse(http.body_str)["items"]

    playlist = []
    parsed.each do |item|
      if item["id"]["kind"] == "youtube#video"
        playlist.push({
          id: item["id"]["videoId"],
          url: "https://www.youtube.com/watch?v=#{item["id"]["videoId"]}",
          title: item["snippet"]["title"],
          thumbnail: {
            url: item["snippet"]["thumbnails"]["high"]["url"],
            width: item["snippet"]["thumbnails"]["high"]["width"],
            height: item["snippet"]["thumbnails"]["high"]["height"],
          }
        })
      end
    end

    render json: { data: playlist }
  end


end
