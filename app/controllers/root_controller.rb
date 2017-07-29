class RootController < ApplicationController

  def index
    Track.count
    render plain: "Ready!"
  end

end
