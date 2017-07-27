class Track < ApplicationRecord
  has_attached_file :track,
    use_timestamp: false
  do_not_validate_attachment_file_type :track

  BITRATES = [
    "96",
    "128",
    "192",
    "256"
  ]

  BITRATE_TYPES = [
    :abr,
    :vbr,
    :cbr
  ]

  def self.get_bitrates
    BITRATES
  end

  def self.get_bitrate_types
    BITRATE_TYPES
  end


end
