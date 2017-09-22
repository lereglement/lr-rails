# encoding: utf-8
require 'net/http'
require 'json'

class Landing::WelcomeController < Landing::BaseController

  def index
    set_meta_tags default_meta_tags
    set_meta_tags title: "Le Règlement"

    @current_track = OpenStruct.new(Data::V1::Tracks::TrackSerializer.new(Track.get_current, root: false).to_hash)
    @previous_tracks = []
    Track.get_previous(3).each do |track|
      @previous_tracks.push(OpenStruct.new(Data::V1::Tracks::TrackSerializer.new(track, root: false).to_hash))
    end

    playlist_url = 'http://cache.lereglement.sale/youtube_videos'
    playlist_uri = URI(playlist_url)
    playlist_response = Net::HTTP.get(playlist_uri)
    if !playlist_response.blank?
      @videos = JSON.parse(playlist_response)['data'].map! do |video|
        OpenStruct.new(video)
      end
    else
      @videos = []
    end

    @networks = [
      {
        slug: 'facebook',
        link: 'https://facebook.com/lereglement/'
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
