class Bucket < ApplicationRecord

  belongs_to :track
  belongs_to :tag, optional: true

end
