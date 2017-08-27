# encoding: utf-8
class Landing::WelcomeController < Landing::BaseController

  def index
    set_meta_tags default_meta_tags
    set_meta_tags title: "REGLEMENT.SALE"
    @current_track = Track.get_current
    # http://data.lereglement.sale/v1/playlists/current
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
