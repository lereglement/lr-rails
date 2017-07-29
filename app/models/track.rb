class Track < ApplicationRecord
  has_attached_file :track,
    use_timestamp: false
  validates_attachment_file_name :track, :matches => %r{\.(mp3|ogg)$}i

  has_attached_file :cover, styles: {
    xsmall: '100x100#',
    small: '200x200#',
    medium: '400x400#',
    large: '600x600#',
    xlarge: '800x800#',
  }, :default_url => "/missing/cover.png",
  use_timestamp: false
  validates_attachment_content_type :cover, :content_type => /\Aimage\/.*\Z/

  after_create :set_after_create

  TYPES = [
    :track,
    :jingle
  ]

  STATES = [
    :active,
    :pending,
    :deleted,
    :expired,
    :striked,
  ]

  def self.get_types
    TYPES
  end

  def self.get_states
    STATES
  end

  def set_after_create
    passphrase = "#{self.id}+#{DateTime.now.to_date}#{Rails.application.secrets.secret_key_base}"
    self.ref = CryptLib.sha1(passphrase)
    self.save
  end

end
