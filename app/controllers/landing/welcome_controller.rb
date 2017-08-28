# encoding: utf-8
require 'net/http'
require 'json'

class Landing::WelcomeController < Landing::BaseController

  def index
    set_meta_tags default_meta_tags
    set_meta_tags title: "LEREGLEMENT.SALE"
    if Rails.env.production?
      @current_track = Track.get_current
    else
      url = 'http://data.lereglement.sale/v1/playlists/current'
      uri = URI(url)
      response = Net::HTTP.get(uri)
      @current_track = OpenStruct.new(JSON.parse(response)['data'])
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
