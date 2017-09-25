class Bucket < ApplicationRecord

  belongs_to :track
  belongs_to :tag, optional: true

  scope :filter_tag, -> (tag) { where(tag_id: Tag.get_id(tag)) }

end
