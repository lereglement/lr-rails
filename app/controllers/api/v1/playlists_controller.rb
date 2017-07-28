class Api::V1::PlaylistsController < Api::V1::BaseController

  def get_next
    next_track = Playlist.where(is_aired: false).order(:id).first

    if next_track.blank?
      to_insert = []
      Track.order("RAND()").pluck(:id).each do |track_id|
        to_insert.push({
          track_id: track_id
        })
      end
      Playlist.create(to_insert)
    end

    next_track = Playlist.where(is_aired: false).order(:id).first

    render plain: TrackLib.transcoded_file(Track.find(next_track.track_id),)

  end


end
