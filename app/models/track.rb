class Track < ApplicationRecord
  has_attached_file :track,
    use_timestamp: false
  do_not_validate_attachment_file_type :track

  BITRATE_TYPES = [
    :abr,
    :vbr,
    :cbr
  ]

  def self.bitrate_types
    BITRATE_TYPES
  end


end
