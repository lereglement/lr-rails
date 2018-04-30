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

    def self.get_current_tag_name
      rap_us_night_day = Rails.application.secrets.rap_us_night_day
      rap_us_night_start = Rails.application.secrets.rap_us_night_start
      now = Time.zone.now

      if now.wday == rap_us_night_day && now.hour >= rap_us_night_start
        :us
      else
        :default
      end
    end
end
