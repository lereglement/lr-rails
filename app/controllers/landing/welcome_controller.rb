# encoding: utf-8
require 'net/http'
require 'json'

class Landing::WelcomeController < Landing::BaseController
  include ApplicationHelper

  def index
    set_meta_tags default_meta_tags
    set_meta_tags title: "Le Règlement"

    @videos = get_youtube_videos({results: 20, remove_live: 1}).map! do |video|
      OpenStruct.new(video)
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
