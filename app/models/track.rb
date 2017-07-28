class Track < ApplicationRecord
  has_attached_file :track,
    use_timestamp: false
  do_not_validate_attachment_file_type :track

  after_create :set_after_create

  TYPES = [
    :track,
    :jingle
  ]

  STATES = [
    :active,
    :pending,
    :deleted
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
