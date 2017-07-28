class Api::V1::PlaylistsController < Api::V1::BaseController

  def get_next
    next_track = Playlist.where(is_aired: false).order(:id).first

    if next_track.blank?
      to_insert = []
      Track.where(state: :active, is_converted: true, type_of: :track).order("RAND()").pluck(:id).each do |track_id|
        to_insert.push({
          track_id: track_id
        })
      end
      Playlist.create(to_insert)
    end

    next_track = Playlist.where(is_aired: false).order(:id).first

    next_track.update({
      is_aired: true,
      aired_at: Time.now
    })

    render plain: TrackLib.transcoded_file(Track.find(next_track.track_id),)

  end


end
