require "byebug"

class Playlist < ApplicationRecord

  belongs_to :track
  belongs_to :tag, optional: true

  def self.get_non_jingle_tracks
    where.not(:type_of => :jingle)
  end

  def self.get_non_jingle_tracks_since(playlist)
    get_non_jingle_tracks.where("id > ?", playlist.id)
  end

  def self.get_first_unaired
    where(:is_aired => false).order(:id).first
  end

  def self.get_last_aired
    where(:is_aired => true).order(:id => :desc).first
  end

  def self.should_play_jingle
    get_last_aired.id % Rails.application.secrets.jingle_modulo == 0
  end

  def self.get_next_jingle
    last_track = get_last_aired
    if last_track.id % 2 == 0
      Track.where(:type_of => :jingle, :artist => "Jingle officiel").first
    else
      Track.where(:type_of => :jingle, :artist => "Jingle").first
    end
  end

  def self.get_last_auto_feat
    where(:type_of => :auto_feat).order(:id).last
  end

  def self.get_count_since_last_auto_feat
    last_auto_feat = get_last_auto_feat
    last_auto_feat ? get_non_jingle_tracks_since(get_last_auto_feat).count : 0
  end

  def self.get_recently_played_tracks
    where(:is_aired => true).order(:id => :desc).limit(Artist.count / 3)
  end

  def self.get_artists_to_avoid
    recently_played_tracks = get_recently_played_tracks
    Track.get_artists_from_ids(recently_played_tracks.pluck(:track_id))
  end

  def self.get_tracks_to_avoid
    where(:is_aired => true).order(:id => :desc).limit(Track.get_buffer_count).pluck(:track_id)
  end
end
