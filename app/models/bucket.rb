class Bucket < ApplicationRecord

  belongs_to :track
  belongs_to :tag, optional: true

  scope :filter_tag, -> (tag_id) { joins("INNER JOIN tagged_tracks ON tagged_tracks.track_id = buckets.track_id AND tagged_tracks.tag_id = #{tag_id}") }

end
