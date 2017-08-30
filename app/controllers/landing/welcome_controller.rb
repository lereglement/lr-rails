# encoding: utf-8
require 'net/http'
require 'json'

class Landing::WelcomeController < Landing::BaseController

  def index
    set_meta_tags default_meta_tags
    set_meta_tags title: "LEREGLEMENT.SALE"
    if Rails.env.production?
      @current_track = OpenStruct.new(Data::V1::Tracks::TrackSerializer.new(Track.get_current, root: false).to_hash)
    else
      current_track_url = 'http://data.lereglement.sale/v1/playlists/current'
      current_track_uri = URI(current_track_url)
      current_track_response = Net::HTTP.get(current_track_uri)
      @current_track = OpenStruct.new(JSON.parse(current_track_response)['data'])

      playlist_url = 'http://data.lereglement.sale/v1/youtube_videos/playlist?q=analyse'
      playlist_uri = URI(playlist_url)
      playlist_response = Net::HTTP.get(playlist_uri)
      @videos = JSON.parse(playlist_response)['data'].map! do |video|
        OpenStruct.new(video)
      end
    end

    # http://data.lereglement.sale/v1/playlists/previous

    @networks = [
      {
        slug: 'facebook',
        link: 'facebook.com/lereglement/'
      },
      {
        slug: 'instagram',
        link: 'https://www.instagram.com/le_reglement/'
      },
      {
        slug: 'youtube',
        link: 'https://www.youtube.com/channel/UCcqe1EHmdaLVBwfqk5OtmXw'
      },
      {
        slug: 'twitter',
        link: 'https://twitter.com/lereglement'
      }
    ]
    render layout: '../landing/layout'
  end


end
