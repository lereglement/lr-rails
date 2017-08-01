# encoding: utf-8
class Obs::TracksController < Obs::BaseController

  def current
    @current_track = Playlist.where(is_aired: true).order(id: :desc).first.track
    render layout: '../obs/layout'
  end


end
