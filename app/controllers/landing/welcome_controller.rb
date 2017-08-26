# encoding: utf-8
class Landing::WelcomeController < Landing::BaseController

  def index
    set_meta_tags default_meta_tags
    set_meta_tags title: "TITLE ICI"
    render layout: '../landing/layout'
  end


end
