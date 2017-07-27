class Track < ApplicationRecord
  has_attached_file :track,
    use_timestamp: false
  do_not_validate_attachment_file_type :track


end
