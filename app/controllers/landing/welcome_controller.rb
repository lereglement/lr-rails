# encoding: utf-8
class Landing::WelcomeController < Landing::BaseController

  def index
    set_meta_tags default_meta_tags
    set_meta_tags title: "REGLEMENT.SALE"
    @current_track = Track.get_current
    render layout: '../landing/layout'
  end


end
