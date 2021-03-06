class ExternalResourceLib

  # Extracts details from video URL (dailymotion, youtube, vimeo)
  def self.extract_from_url(url)

    if match = /(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/.match(url)

      unless match[1].blank?
        ref = match[1]
        source_url = "https://www.googleapis.com/youtube/v3/videos?key=#{Rails.application.secrets.youtube_api_key}&id=#{ref}&part=id,snippet"
        http = Curl.get(source_url)
        return false if !http.body_str

        parsed = JSON.parse(http.body_str)

        if parsed["items"] && parsed["items"][0] && parsed["items"][0]["snippet"] && parsed["items"][0]["snippet"]["liveBroadcastContent"] == "none"

          snippet = parsed["items"][0]["snippet"]

          return {
            id_source: ref,
            ref: ref,
            origin: :youtube,
            url: "https://www.youtube.com/watch?v=#{ref}",
            thumbnail: "https://img.youtube.com/vi/#{ref}/hqdefault.jpg",
            title: snippet["title"],
            description: snippet["description"],
            published_at: Time.parse(snippet["publishedAt"])
          }

        end

      end

    elsif match = /(?:dailymotion\.com(?:\/video|\/hub)|dai\.ly)\/([0-9a-z]+)(?:[\-_0-9a-zA-Z]+#video=([a-z0-9]+))?/.match(url)

      unless match[1].blank?
        ref = match[1]

        source_url = "http://www.dailymotion.com/services/oembed?format=json&url=http://www.dailymotion.com/embed/video/#{ref}"
        http = Curl.get(source_url)
        return false if !http.body_str

        parsed = JSON.parse(http.body_str)

        return {
          id_source: ref,
          ref: ref,
          origin: :dailymotion,
          url: "https://www.dailymotion.com/video/#{ref}",
          thumbnail: "https://www.dailymotion.com/thumbnail/video/#{ref}",
          title: parsed["title"],
          description: parsed["description"],
          published_at: nil
        }
      end

    elsif match = /https?:\/\/(?:www\.|player\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/([^\/]*)\/videos\/|album\/(\d+)\/video\/|video\/|)(?<id>\d+)(?:$|\/|\?)/.match(url)

      unless match[1].blank?
        ref = match[1]

        source_url = "http://vimeo.com/api/v2/video/#{ref}.json"
        http = Curl.get(source_url)
        return false if !http.body_str

        parsed = JSON.parse(http.body_str)

        if parsed && item = parsed[0]

          return {
            id_source: ref,
            ref: ref,
            origin: :vimeo,
            url: "https://www.dailymotion.com/video/#{ref}",
            thumbnail: item["thumbnail_large"],
            title: item["title"],
            description: item["description"],
            published_at: item["upload_date"]
          }

        end
      end

    elsif match = /^https?:\/\/(m.)?(soundcloud\.com|snd\.sc)\/([a-z_0-9-]+\/[a-z_0-9-]+)(\?.*)?$/.match(url)

      unless match[3].blank?
        ref = match[3]

        xml = HTTParty.get(url)
        if xml.response.code && xml.response.code.to_i == 200
          content_parsed = Nokogiri::HTML(xml.body)

          title = content_parsed.title

          return {
            id_source: ref,
            ref: CryptLib.md5(ref),
            origin: :soundcloud,
            url: "https://soundcloud.com/#{ref}",
            thumbnail: nil,
            title: title,
            description: nil,
            published_at: nil
          }
        end

      end

    end

    return false if !url
  end

end
