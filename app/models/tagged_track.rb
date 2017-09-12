class TaggedTrack < ApplicationRecord
    belongs_to :track
    belongs_to :tag
end
