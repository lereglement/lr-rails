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

      if !has_next_track
        artist_buffer_count = Artist.count / 3
        track_buffer_count = Track.where(state: :active).count / 2

        tracks_with_artists_to_avoid = Playlist.where(is_aired: true).order(id: :desc).limit(artist_buffer_count).pluck(:track_id)
        tracks_to_avoid = Playlist.where(is_aired: true).order(id: :desc).limit(track_buffer_count).pluck(:track_id)
        artists_to_avoid = Track.where(id: tracks_with_artists_to_avoid).pluck(:artist)
      end

      # Play auto featured
      if !has_next_track
        last_auto_feat = Playlist.where(type_of: :auto_feat).order(id: :desc).first
        count_between = last_auto_feat.id ? Playlist.where.not(type_of: :jingle).where("id > ?", last_auto_feat.id).count : 0

        if count_between >= Rails.application.secrets.track_auto_featured_modulo
          auto_featured = Track.where.not(artist: artists_to_avoid).where(state: :active).where("aired_count <= ?", Rails.application.secrets.track_auto_featured_limit).order(:last_aired_at).first

          unless auto_featured.blank?
            Playlist.create({ track_id: auto_featured.id, type_of: :auto_feat })
            has_next_track = true
          end
        end
      end

      # Insert a track
      if !has_next_track

        bucket_pick = Bucket.where.not(artist: artists_to_avoid).where.not(id: tracks_to_avoid).order("RAND()").first

        # Regenerate bucket if can't find tracks
        if bucket_pick.blank?
          Bucket.delete_all

          to_insert = []
          Track.where(state: :active, is_converted: true, type_of: :track).order("RAND()").each do |track|
            to_insert.push({
              track_id: track.id,
              artist: track.artist
            })
          end
          Bucket.create(to_insert)

          bucket_pick = Bucket.where.not(artist: artists_to_avoid).order("RAND()").first
        end

        unless bucket_pick.blank?
          Playlist.create({ track_id: bucket_pick.track_id, type_of: :bucket })
          has_next_track = true
        end

        Bucket.find_by(track_id: bucket_pick.track_id).delete if bucket_pick

      end

      if !has_next_track

        to_play = Track.where(state: :active, is_converted: true, type_of: :track).where.not(artist: artists_to_avoid).order("RAND()").first

        to_play = Track.where(state: :active, is_converted: true, type_of: :track).order("RAND()").first if to_play.blank?

        Playlist.create({ track_id: to_play.id, type_of: :random })
        has_next_track = true

        Bucket.delete_all

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

  def get_current
    current_track = Track.get_current

    render json: current_track,
      root: 'data',
      serializer: Api::V1::Tracks::TrackSerializer
  end


end
