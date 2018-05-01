class Bucket < ApplicationRecord

  belongs_to :track
  belongs_to :tag, optional: true

  scope :filter_tag, -> (tag) { where(tag_id: Tag.get_id(tag)) }

  def self.pick_next(tag=:default)
    pick = get_random_track_for_tag(tag)
    if pick.blank?
      regenerate_for_tag(tag)
      pick = get_random_track_for_tag(tag)
    end
    pick
  end

  def self.get_random_track_for_tag(tag)
    filter_tag(tag).where.not(artist: Playlist.get_artists_to_avoid).where.not(id: Playlist.get_tracks_to_avoid).order("RAND()").first
  end

  def self.delete_all_for_tag(tag)
    filter_tag(tag).delete_all
  end

  def self.delete_by_track_id(track_id)
    find_by(:track_id => track_id).delete
  end

  def self.regenerate_for_tag(tag)
    delete_all_for_tag(tag)

    to_insert = []
    Track.get_playable_tracks_for_tag(tag).each do |track|
      to_insert.push({
        track_id: track.id,
        artist: track.artist,
        tag_id: Tag.get_id(tag)
      })
    end
    Bucket.create(to_insert)
  end
end
