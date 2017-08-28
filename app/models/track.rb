class Track < ApplicationRecord
  has_attached_file :track,
    use_timestamp: false
  do_not_validate_attachment_file_type :track
  # validates_attachment_file_name :track, :matches => %r{\.(mp3|ogg)$}i

  has_attached_file :cover, styles: {
    xsmall: '100x100#',
    small: '200x200#',
    medium: '400x400#',
    large: '600x600#',
    xlarge: '800x800#',
  }, :default_url => "/missing/cover.png",
  use_timestamp: false
  validates_attachment_content_type :cover, :content_type => /\Aimage\/.*\Z/

  scope :external_source_missing_in, -> (bool) {
    where(" external_source IS NULL OR external_source = '' ")
  }

  def self.ransackable_scopes(_auth_object = nil)
    [:external_source_missing_in]
  end

  after_create :set_after_create
  before_save :insert_artist
  after_save :set_after_save
  before_destroy :set_before_destroy

  TYPES = [
    :track,
    :jingle
  ]

  STATES = [
    :active,
    :pending,
    :rejected,
    :expired,
    :striked,
    :wip,
    :to_review,
    :suggested,
  ]

  def self.get_types
    TYPES
  end

  def self.get_states
    STATES
  end

  def self.get_state_to_check
    [
      :active,
      :pending,
      :expired,
      :striked,
      :wip,
      :to_review,
      :suggested,
    ]
  end

  def set_after_create
    passphrase = "#{self.id}+#{DateTime.now.to_date}#{Rails.application.secrets.secret_key_base}"
    self.ref = CryptLib.sha1(passphrase)
    self.save
  end

  def set_after_save
    if saved_change_to_external_source? || (self.external_source && !self.ref_external_source)
      source_details = ExternalResourceLib.extract_from_url(self.external_source)

      if source_details
        self.update_column(:ref_external_source, source_details[:ref])
        self.update_column(:origin_external_source, source_details[:origin])
      end
    end

    if self.state && self.state.to_sym != :active
      Bucket.where(track_id: self.id).delete_all
    end
  end

  def set_before_destroy
    Bucket.where(track_id: self.id).delete_all
    Playlist.where(track_id: self.id).delete_all
  end

  def self.get_current
    playlist_current = Playlist.joins("INNER JOIN tracks ON tracks.id = playlists.track_id AND tracks.type_of = 'track'").where(is_aired: true).order(id: :desc).first
    playlist_current.blank? ? nil : playlist_current.track
  end

  def self.get_previous(limit)
    playlist = Playlist.joins("INNER JOIN tracks ON tracks.id = playlists.track_id AND tracks.type_of = 'track'").where(is_aired: true).order(id: :desc).limit(limit).offset(1)

    return nil if playlist.blank?

    tracks = []
    playlist.each do |item|
      tracks.push(item.track) unless item.track.blank?
    end
    tracks
  end

  def insert_artist
    if self.artist
      Artist.where(name: self.artist).first_or_create
    end
  end

  def transcoded_file
    if self.track.path
      filename = self.track.path.scan(/original\/(\w+)/)[0][0]
      "/transcoded/#{filename.scan(/.{4}/).join("/")}/#{Rails.application.secrets.output_quality}.#{Rails.application.secrets.output_format}"
    end
  end

  def check_errors
    require 'net/http'
    errors = []
    # Check source
    errors.push("Filename missing in db") unless self.track.path
    if self.track.path
      uri = URI(self.track.url)
      request = Net::HTTP.new uri.host
      response = request.request_head uri.path
      errors.push("Header for file #{response.code}") if response.code.to_i != 200
    end

    errors.push("Duration missing") unless self.duration
    errors.push("Duration converted missing") unless self.duration_converted


    if errors.length > 0
      self.update(error_logs: errors.join(','), state: :to_review)
      Bucket.where(track_id: self.id).delete_all
    end
  end

  def self.get_hours(aired_count_min, state = :active)
    hours = Track.select("
      SUM(duration)/60/60 AS hours
    ")
    .where(state: state)
    .where("aired_count < ?", aired_count_min).first["hours"]
    hours.round(1) if hours
  end

end
