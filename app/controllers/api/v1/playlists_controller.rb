class Api::V1::PlaylistsController < Api::V1::BaseController

  def get_next
    next_track = Playlist.where(is_aired: false).order(:id).first

    has_next_track = next_track.blank? ? false : true

    if !has_next_track

      last_track = Playlist.where(is_aired: true).order(id: :desc).first

      # Play a jingle
      if last_track.id % Rails.application.secrets.jingle_modulo == 0

        # Play official jingle
        if last_track.id % 2 == 0
          jingle = Track.where(type_of: :jingle, artist: "Jingle officiel").first
        else
          jingle = Track.where(type_of: :jingle, artist: "Jingle").order(:last_aired_at).first
        end

        unless jingle.blank?
          Playlist.create({ track_id: jingle.id, type_of: :jingle })
          has_next_track = true
        end

      end

      # Insert a track
      if !has_next_track

        artist_buffer_count = Artist.count / 3

        p "BUFFER: #{artist_buffer_count}"
        tracks_with_artists_to_avoid = Playlist.where(is_aired: true).order(id: :desc).limit(artist_buffer_count).pluck(:track_id)
        p ">>>>>>>>>>>>>tracks_with_artists_to_avoid: #{artist_buffer_count}"
        artists_to_avoid = Track.where(id: tracks_with_artists_to_avoid).pluck(:artist)
        p ">>>>>>>>>>>>>artists_to_avoid: #{artists_to_avoid}"

        bucket_pick = Bucket.where.not(artist: artists_to_avoid).order("RAND()").first

        if bucket_pick.blank?
          to_insert = []
          Track.where(state: :active, is_converted: true, type_of: :track).order("RAND()").each do |track|
            to_insert.push({
              track_id: track.id,
              artist: track.artist
            })
          end
          Bucket.create(to_insert)
          p "@@@@@@@@@@@@@@@ INSERTING  @@@@@@@@@@@@@@@@@@@@2"

          bucket_pick = Bucket.where.not(artist: artists_to_avoid).order("RAND()").first
        end

        unless bucket_pick.blank?
          Playlist.create({ track_id: bucket_pick.track_id, type_of: :bucket })
          has_next_track = true
        end

        Bucket.find_by(track_id: bucket_pick.track_id).delete

      end

      if !has_next_track

        to_play = Track.where(state: :active, is_converted: true, type_of: :track).where.not(artist: artists_to_avoid).order("RAND()").first
        Playlist.create({ track_id: to_play.id, type_of: :random })

      end

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
  #
  # def get_next
  #   next_track = Playlist.where(is_aired: false).order(:id).first
  #
  #   if next_track.blank?
  #     to_insert = []
  #     Track.where(state: :active, is_converted: true, type_of: :track).order("RAND()").pluck(:id).each do |track_id|
  #       to_insert.push({
  #         track_id: track_id
  #       })
  #     end
  #     Playlist.create(to_insert)
  #
  #     next_track = Playlist.where(is_aired: false).order(:id).first
  #   end
  #
  #   next_track.update({
  #     is_aired: true,
  #     aired_at: Time.now
  #   })
  #
  #   track = Track.find(next_track.track_id)
  #   track.update(last_aired_at: Time.now)
  #   track.increment!(:aired_count)
  #
  #   render json: next_track,
  #     root: 'data',
  #     serializer: Api::V1::Playlists::NextSerializer
  #
  # end


end
