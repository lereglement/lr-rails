class Api::V1::PlaylistsController < Api::V1::BaseController

  def get_next
    tag = Tag.get_current_tag_name

    next_track = Playlist.get_first_unaired

    # jingle?
    if next_track.blank?
      if Playlist.should_play_jingle
        jingle = Playlist.get_next_jingle

        if jingle
          next_track = Playlist.create({ track_id: jingle.id, type_of: :jingle })
        end
      end

      # auto feat?
      if next_track.blank? && tag == :default
        autofeat = Playlist.get_next_valid_auto_feat_for_tag(tag)

        if autofeat
          next_track = Playlist.create({ track_id: autofeat.id, type_of: :auto_feat, tag_id: Tag.get_id(tag) })
        end
      end

      # Insert a track
      if next_track.blank?
        bucket_pick = Bucket.pick_next(tag)

        if bucket_pick
          next_track = Playlist.create({ track_id: bucket_pick.track_id, type_of: :bucket, tag_id: Tag.get_id(tag) })
          Bucket.delete_by_track_id(bucket_pick.track_id)
        end
      end

      if next_track.blank?
        to_play = Track.get_random_track_for_tag_filtered_for_artists(tag, Playlist.get_artists_to_avoid)
        to_play ||= Track.get_random_track_for_tag(tag)

        next_track = Playlist.create({ track_id: to_play.id, type_of: :random, tag_id: Tag.get_id(tag) })
        Bucket.filter_tag(tag).delete_all
      end
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
