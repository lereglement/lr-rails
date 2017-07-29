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

      next_track = Playlist.where(is_aired: false).order(:id).first
    end

    next_track.update({
      is_aired: true,
      aired_at: Time.now
    })

    track = Track.find(next_track.track_id)
    track.update(last_aired_at: Time.now)
    track.increment!(:aired_count)

    render json: next_track,
      root: 'data',
      serializer: Api::V1::Playlists::NextSerializer

  end


end
