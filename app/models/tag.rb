class Tag < ApplicationRecord

    has_many :tagged_tracks
    has_many :tracks, through: :tagged_tracks
    accepts_nested_attributes_for :tagged_tracks

end
