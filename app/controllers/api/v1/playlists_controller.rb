class Api::V1::PlaylistsController < Api::V1::BaseController

  def get_next
    tag = Tag.get_current_tag_name

    next_track = Playlist.get_first_unaired

    has_next_track = next_track.blank? ? false : true

    if !has_next_track
      # Play a jingle
      if Playlist.should_play_jingle
        jingle = Playlist.get_next_jingle

        unless jingle.blank?
          Playlist.create({ track_id: jingle.id, type_of: :jingle })
          has_next_track = true
        end
      end

      if !has_next_track
        artists_to_avoid = Playlist.get_artists_to_avoid
      end

      # Play auto featured
      if !has_next_track && tag == :default
        auto_featured = Playlist.get_next_valid_auto_feat_for_tag(tag)

        unless auto_featured.blank?
          Playlist.create({ track_id: auto_featured.id, type_of: :auto_feat, tag_id: Tag.get_id(tag) })
          has_next_track = true
        end
      end

      # Insert a track
      if !has_next_track
        bucket_pick = Bucket.pick_next(tag)

        unless bucket_pick.blank?
          Playlist.create({ track_id: bucket_pick.track_id, type_of: :bucket, tag_id: Tag.get_id(tag) })
          Bucket.delete_by_track_id(bucket_pick.track_id)
          has_next_track = true
        end
      end

      if !has_next_track
        to_play = Track.filter_tag(tag).where(state: :active, is_converted: true, type_of: :track).where.not(artist: artists_to_avoid).order("RAND()").first

        to_play = Track.filter_tag(tag).where(state: :active, is_converted: true, type_of: :track).order("RAND()").first if to_play.blank?

        Playlist.create({ track_id: to_play.id, type_of: :random, tag_id: Tag.get_id(tag) })
        has_next_track = true

        Bucket.filter_tag(tag).delete_all

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
