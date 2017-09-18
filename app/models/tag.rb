class Tag < ApplicationRecord

    has_many :tagged_tracks
    has_many :tracks, through: :tagged_tracks
    accepts_nested_attributes_for :tagged_tracks

    IDS = {
      default: 1,
      us: 2
    }

    def self.get_ids
      IDS
    end

    def self.get_id(tag)
      IDS[tag]
    end

end
